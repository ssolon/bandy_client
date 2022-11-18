import 'package:bandy_client/exercise/current/current_exercise_state.dart';
import 'package:bandy_client/exercise/exercise.dart';
import 'package:bandy_client/exercise/exercise_dummys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'current_exercise_notifier.g.dart';

@riverpod
class CurrentExerciseNotifier extends _$CurrentExerciseNotifier {
  @override
  CurrentExerciseState build() {
    return CurrentExerciseState.initial();
  }

  void setExerciseById(UuidValue? id) {
    if (id == null) {
      state = CurrentExerciseState.initial();
    } else {
      final exercise = dummyExercises[id];
      state = exercise == null
          ? CurrentExerciseState.error('Exercise=$id is not known')
          : CurrentExerciseState(exercise: exercise);
    }
  }

  void setExercise(Exercise exercise) {
    state = CurrentExerciseState(exercise: exercise);
  }
}
