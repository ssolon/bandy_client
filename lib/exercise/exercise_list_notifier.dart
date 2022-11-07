import 'package:bandy_client/exercise/exercise_dummys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'exercise_list_state.dart';

part 'exercise_list_notifier.g.dart';

@riverpod
class ExerciseListNotifier extends _$ExerciseListNotifier {
  @override
  ExerciseListState build() {
    // TODO Replace dummy items (obviously)
    return ExerciseListState(items: [
      for (final e in dummyExercises.entries)
        ExerciseListItem(id: e.key, name: e.value)
    ]);
  }
}
