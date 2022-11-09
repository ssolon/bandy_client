import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'workout_session_state.dart';

part 'workout_session_notifier.g.dart';

@riverpod
class WorkoutSessionNotifier extends _$WorkoutSessionNotifier {
  @override
  WorkoutSessionState build() {
    return WorkoutSessionState.initial();
  }

  /// Create a new session starting now
  void start() {
    state = WorkoutSessionState(
        id: const Uuid(), starting: DateTime.now(), sets: []);
  }
}
