import 'package:bandy_client/exercise/current/current_exercise_state.dart';
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
      final name = dummyExercises[id];
      state = name == null
          ? CurrentExerciseState.error('Exercise=$id is not known')
          : CurrentExerciseState(id: id, name: name);
    }
  }
}
