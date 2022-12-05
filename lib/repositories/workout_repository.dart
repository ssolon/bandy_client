import 'dart:convert';

import 'package:bandy_client/exercise/exercise.dart';
import 'package:bandy_client/main.dart';
import 'package:bandy_client/repositories/db/init_bandy_db.dart';
import 'package:bandy_client/repositories/db/kaleidalog_sqlite.dart';
import 'package:bandy_client/workout_session/workout_session_notifier.dart';
import 'package:bandy_client/workout_session/workout_session_state.dart';
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
  Future<void> persistSession(UuidValue? id, DateTime starting, DateTime ending,
      List<WorkoutSetState> sets) async {
    final sessionId = await ref.read(kaleidaLogDbProvider).createEvent(
          eventId: id,
          at: starting,
          eventTypeId: UuidValue(sessionTypeUUID),
          jsonDetails: json.encode({'ending': ending.toIso8601String()}),
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
            'exercise_id': workoutSet.exercise!.id,
          },
          'count': repCounts.length,
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
}
