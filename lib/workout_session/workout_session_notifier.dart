import 'dart:convert';
import 'dart:io';

import 'package:bandy_client/main.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_state.dart';
import 'package:loggy/loggy.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'workout_session_state.dart';

part 'workout_session_notifier.g.dart';

@Riverpod(keepAlive: true)
class WorkoutSessionNotifier extends _$WorkoutSessionNotifier with UiLoggy {
  Uuid? currentSessionId;
  List<WorkoutSetState> sets = [];

  @override
  WorkoutSessionState build() {
    return WorkoutSessionState.initial();
  }

  /// Initial
  void initial() {
    state = WorkoutSessionState.initial();
  }

  /// Create a new session starting now
  void start() {
    sets = [];
    state = WorkoutSessionState(starting: DateTime.now(), sets: sets);
  }

  /// Add a set to this session
  void addSet(WorkoutSetState workoutSet) {
    workoutSet.maybeMap((set) {
      state.maybeMap((inProgress) {
        setSave(set);
        sets.add(set);
        state = inProgress.copyWith(sets: sets);
      }, orElse: () {});
    }, orElse: () {
      // Ignore anything other than Data
      // TODO Some sort of warning logging/display
    });
  }

  /// End the current session
  void finish() {
    state = state.maybeWhen(
      (starting, sets) => WorkoutSessionState.completed(
          starting: starting, ending: DateTime.now(), sets: sets),
      orElse: () => WorkoutSessionState.error(
          "Session cannot be finished (state = ${state.runtimeType})"),
    );
  }

  ///!!!! Temporary development code
  // TODO REMOVE THIS !!!!
  void setSave(WorkoutSetState set) {
    final json = set.mapOrNull((value) => value.reps.map((e) => jsonEncode(e)));
    if (json != null) {
      final f =
          File(p.join(storageDirectory!.path, "set${DateTime.now()}.json"));
      f.writeAsStringSync(json.join('\n'));
      loggy.debug(json);
    }
  }
}
