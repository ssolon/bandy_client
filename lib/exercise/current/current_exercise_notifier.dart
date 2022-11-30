import 'package:bandy_client/exercise/current/current_exercise_state.dart';
import 'package:bandy_client/exercise/exercise.dart';
import 'package:bandy_client/exercise/exercise_dummys.dart';
import 'package:bandy_client/exercise/list/exercise_list_notifier.dart';
import 'package:bandy_client/exercise/list/exercise_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'current_exercise_notifier.g.dart';

@riverpod
class CurrentExerciseNotifier extends _$CurrentExerciseNotifier {
  Map<UuidValue, Exercise> exercises = {};

  _makeExercises(List<ExerciseListItem> listItems) {
    exercises = {for (var e in listItems) e.id: Exercise(e.id, e.name)};
  }

  @override
  CurrentExerciseState build() {
    ref.listen(
      exerciseListNotifierProvider,
      (previous, AsyncValue<ExerciseListState> next) {
        next.whenData((value) {
          exercises =
              value.maybeWhen((data) => _makeExercises(data), orElse: () => {});
        });
      },
    );
    return CurrentExerciseState.initial();
  }

  void setExerciseById(UuidValue? id) {
    if (id == null) {
      state = CurrentExerciseState.initial();
    } else {
      final listItem = exercises[id];

      state = listItem == null
          ? CurrentExerciseState.error('Exercise=$id is not known')
          : CurrentExerciseState(
              exercise: Exercise(listItem.id, listItem.name));
    }
  }

  void setExercise(Exercise? exercise) {
    state = exercise == null
        ? CurrentExerciseState.initial()
        : CurrentExerciseState(exercise: exercise);
  }
}
