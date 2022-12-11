import 'package:bandy_client/repositories/workout_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'workout_session_list_notifier.freezed.dart';
part 'workout_session_list_notifier.g.dart';

@freezed
class WorkoutSessionListState with _$WorkoutSessionListState {
  const factory WorkoutSessionListState(
      {required List<WorkoutSessionListItem> items}) = _WorkoutSessionListState;
}

@freezed
class WorkoutSessionListItem with _$WorkoutSessionListItem {
  const factory WorkoutSessionListItem(
      {required UuidValue sessionId,
      required DateTime sessionAt}) = _WorkoutSessionListItem;
}

@riverpod
class WorkoutSessionListNotifier extends _$WorkoutSessionListNotifier {
  @override
  FutureOr<WorkoutSessionListState> build() async {
    return fetch();
  }

  /// Reload the sessions list from the source
  void reload() async {
    state = AsyncValue.data(await fetch());
  }

  FutureOr<WorkoutSessionListState> fetch() async {
    return WorkoutSessionListState(items: [
      for (final session
          in await ref.read(workoutRepositoryProvider).getSessions())
        WorkoutSessionListItem(
            sessionAt: DateTime.parse(session['event_at'].toString()),
            sessionId: UuidValue(session['event_id'].toString()))
    ]);
  }
}
