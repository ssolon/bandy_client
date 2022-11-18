import 'package:bandy_client/routine/workout_set/logic/workout_set_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'workout_session_state.dart';

part 'workout_session_notifier.g.dart';

@riverpod
class WorkoutSessionNotifier extends _$WorkoutSessionNotifier {
  Uuid? currentSessionId;

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
    state = WorkoutSessionState(starting: DateTime.now(), sets: []);
  }

  /// Add a set to this session
  /// TODO Implement this
  void addSet(WorkoutSetState workoutSet) {
    workoutSet.maybeMap((set) {
      state.maybeMap((value) => null, orElse: () {});
    }, orElse: () {
      // Ignore anything other than Data
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
}
