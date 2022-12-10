import 'package:bandy_client/repositories/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../current/workout_session_state.dart';

part 'workout_session_details_notifier.g.dart';

@riverpod
class WorkoutSessionDetailsNotifier extends _$WorkoutSessionDetailsNotifier {
  @override
  FutureOr<WorkoutSessionState> build(UuidValue sessionId) async {
    return ref.read(workoutRepositoryProvider).getSession(sessionId);
  }
}
