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
