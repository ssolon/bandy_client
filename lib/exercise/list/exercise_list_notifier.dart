import 'package:bandy_client/exercise/exercise_dummys.dart';
import 'package:bandy_client/repositories/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'exercise_list_state.dart';

part 'exercise_list_notifier.g.dart';

@riverpod
class ExerciseListNotifier extends _$ExerciseListNotifier {
  @override
  FutureOr<ExerciseListState> build() async {
    // Just get the current items from the repository for now
    // TODO Routine handling of predefined exercise lists

    return ExerciseListState(items: [
      for (final e in await ref.read(workoutRepositoryProvider).getExercises())
        ExerciseListItem(
            id: UuidValue(e['event_type_id'].toString()),
            name: e['event_type_name'].toString())
    ]);
  }
}
