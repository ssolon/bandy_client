import 'dart:convert';

import 'package:bandy_client/exercise/exercise.dart';
import 'package:bandy_client/main.dart';
import 'package:bandy_client/repositories/db/init_bandy_db.dart';
import 'package:bandy_client/repositories/db/kaleidalog_sqlite.dart';
import 'package:bandy_client/workout_session/current/workout_session_notifier.dart';
import 'package:bandy_client/workout_session/current/workout_session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../routine/rep_counter.dart';
import '../routine/workout_set/logic/workout_set_state.dart';

final workoutRepositoryProvider = Provider((ref) => WorkoutRepository(ref));

const kaleidaTagBandy = 'bandy';
const kaleidaTagExercise = 'exercise';

class WorkoutRepository {
  final Ref ref;

  WorkoutRepository(this.ref) {
    ref.listen(workoutSessionNotifierProvider,
        (previous, WorkoutSessionState next) async => saveSession(next));
  }

  /// Return all bandy exercises
  Future<QueryResult> getExercises() async {
    final tags = [kaleidaTagBandy, kaleidaTagExercise];
    final exercises =
        ref.read(kaleidaLogDbProvider).fetchEventTypesByTags(tags);

    // TODO DTO objects?
    return exercises;
  }

  /// Return all sessions
  Future<QueryResult> getSessions() async {
    final sessions = ref.read(kaleidaLogDbProvider).fetchSessions();

    return sessions;
  }

  /// Persist [theWorkoutSession] to the persistence store.
  Future<void> saveSession(WorkoutSessionState theWorkoutSession) async {
    theWorkoutSession.maybeWhen(
      (starting, sets) => {}, // ignore
      completed: (id, starting, ending, sets) =>
          persistSession(id, starting, ending, sets),
      error: (message) => talker.error("Save set data has error=$message"),
      orElse: () => talker
          .error("Save set given non-data ${theWorkoutSession.runtimeType}"),
    );
  }

  // Convert to a series of kaleidalog events
  // TODO Wrap these in a transaction?
  Future<void> persistSession(UuidValue? id, DateTime starting,
      DateTime? ending, List<WorkoutSetState> sets) async {
    final details = ending == null
        ? null
        : json.encode("{'ending': ${ending.toIso8601String()}}");

    final sessionId = await ref.read(kaleidaLogDbProvider).createEvent(
          eventId: id,
          at: starting,
          eventTypeId: UuidValue(sessionTypeUUID),
          jsonDetails: details,
        );

    for (final s in sets) {
      s.maybeMap((value) async => await persistSet(sessionId, value),
          orElse: () =>
              throw ("Invalid state for persistSet=${s.runtimeType}"));
    }
  }

  /// Persist [workoutSet] and all the children reps
  Future<void> persistSet(UuidValue parentId, Data workoutSet) async {
    // Take the event start from the first rep, if any.
    // Ignore a set with no reps

    final repCounts = workoutSet.reps;
    if (repCounts.isNotEmpty) {
      final maybeStarting = startingOf(repCounts.first.reps);

      maybeStarting.match(() {}, // ignore empty sets (shouldn't happen)
          (starting) async {
        final details = json.encode({
          if (workoutSet.exercise != null) ...{
            'exercise': workoutSet.exercise!.name,
            'exercise_id': workoutSet.exercise!.id.toString(),
          },
          'set_number': workoutSet.setNumber,
          // TODO Add "effort" when we compute it
        });
        final setId = await ref.read(kaleidaLogDbProvider).createEvent(
            at: starting,
            eventTypeId: UuidValue(workoutSetTypeUUID),
            parentId: parentId,
            jsonDetails: details);
        for (final r in repCounts) {
          persistRep(setId, r, workoutSet.exercise);
        }
      });
    }
  }

  /// Persist the reps in [repCount].
  Future<void> persistRep(
      UuidValue parentId, RepCount repCount, Exercise? exercise) async {
    startingOf(repCount.reps).match(
      () {/* ignore empty */},
      (starting) async {
        final details = json.encode(repCount);

        await ref.read(kaleidaLogDbProvider).createEvent(
            at: starting,
            eventTypeId: exercise?.id ?? UuidValue(exerciseRepTypeUUID),
            parentId: parentId,
            jsonDetails: details);
      },
    );
  }

  /// Return the time of the first rep in [repCount] or null if there are
  /// no reps.
  Option<DateTime> startingOf(Rep rep) {
    final instants = rep.instants;

    return instants.isNotEmpty ? Option.of(instants.first.when) : Option.none();
  }

  /// Get the session for [sessionId]
  Future<WorkoutSessionState> getSession(UuidValue sessionId) async {
    final sessionEvents =
        await ref.read(kaleidaLogDbProvider).fetchSession(sessionId);

    // TODO Error handling here or let the notifier handle it via AsyncValue?

    if (sessionEvents.isEmpty) {
      return Future.error("No session with id=$sessionId");
    }

    // The first entry should be the session -- or our SQL is broken

    final firstEvent = sessionEvents.first;
    if (typeId(firstEvent) != sessionTypeUUID) {
      return Future.error(
          "Malformed session - no session header (type=${type(firstEvent)}");
    }

    // Double check the sessionId is what we wanted
    final eventSessionId = firstEvent[eventIdColumn].toString();
    if (eventSessionId != sessionId.toString()) {
      return Future.error("Fetch sessionId = $eventSessionId != $sessionId");
    }

    // Create the result session
    var result = WorkoutSessionState.completed(
        id: UuidValue(sessionId.toString()),
        starting: at(firstEvent),
        sets: []);

    // Iterate over the rest of the events rebuilding the session

    WorkoutSetState? currentSet;

    for (final event in sessionEvents.skip(1)) {
      switch (typeId(event)) {
        case workoutSetTypeUUID:
          if (currentSet != null) {
            result = addSet(result, currentSet);
          }

          // Start the next set, if any
          currentSet = makeWorkoutSet(event);

          break;

        default: // Should be a rep so add it the current set
          currentSet = addRep(currentSet!, event);
          break;
      }
    }

    // Add the last set
    if (currentSet != null) {
      if (currentSet.maybeWhen((exercise, setNumber, reps) => reps.isNotEmpty,
          orElse: () => false)) {
        result = addSet(result, currentSet);
      }
    }
    return Future.value(result);
  }

  /// Add [set] to [session] returning the updated session.
  WorkoutSessionState addSet(WorkoutSessionState session, WorkoutSetState set) {
    return session.maybeMap(
        (s) => throw Exception("Unexpected session state InProgress"),
        completed: (s) => s.copyWith(sets: List.from(s.sets)..add(set)),
        orElse: () => throw Exception(
            "Unexpected session state=${session.runtimeType} expected completed"));
  }

  /// Create a workoutSet from [row]
  WorkoutSetState makeWorkoutSet(TableRow row) {
    final details = json.decode(row[eventDetailsColumn].toString());

    return WorkoutSetState(
      exercise: exerciseFromDetails(details),
      setNumber: details['set_number'] ?? 0,
      reps: [],
    );
  }

  Exercise? exerciseFromDetails(details) {
    final id = details['exercise_id'];
    return id == null
        ? null
        : Exercise(UuidValue(id), details['exercise'] ?? '');
  }

  /// Create a RepCount from [row] and add it to [set] returning the updated
  /// [WorkoutSetState].
  WorkoutSetState addRep(WorkoutSetState workoutSet, TableRow row) {
    final repCount =
        RepCount.fromJson(json.decode(row[eventDetailsColumn].toString()));
    return workoutSet.maybeMap(
        (w) => w.copyWith(reps: List<RepCount>.from(w.reps)..add(repCount)),
        orElse: () => throw Exception(
            "addRep:Unexpected workoutSet state=${workoutSet.runtimeType}"));
  }

  DateTime at(TableRow row) {
    return DateTime.parse(row[eventAtColumn] as String);
  }

  String type(TableRow row) {
    return row[eventTypeNameColumn].toString();
  }

  String typeId(TableRow row) {
    return row[eventTypeIdColumn].toString();
  }
}
