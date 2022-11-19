import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/exercise/current/current_exercise_notifier.dart';
import 'package:bandy_client/exercise/exercise.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:bandy_client/workout_session/workout_session_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../exercise/current/current_exercise_state.dart';
import 'workout_set_state.dart';

part 'workout_set_notifier.g.dart';

@riverpod
class WorkoutSetNotifier extends _$WorkoutSetNotifier {
  late final ScannedDevice device;

  List<RepCount> reps = [];
  int setCount = 1;

  Exercise? currentExercise;

  @override
  WorkoutSetState build(ScannedDevice d) {
    device = d;
    ref.listen(
      currentExerciseNotifierProvider,
      (previous, CurrentExerciseState next) {
        setCurrentExercise(next.whenOrNull((exercise) => exercise));
      },
    );
    ref.listen(repCounterStateProvider(device),
        (RepCount? previous, RepCount next) {
      if (next.count == 0) {
        // Ignore initial
        // TODO Use Rep to indicate?
      } else {
        reps.add(next);
        state = _createState();
      }
    });

    // End set on button click
    // TODO Have rep counter feed back a reset
    ref.listen(
      button1ClickedProvider(device),
      (previous, next) {
        ref.read(repCounterStateProvider(device).notifier).reset();
        endSet();
      },
    );
    return const WorkoutSetState.initial();
  }

  /// Handle changing the current exercise by ending the current set
  /// and starting a new set
  void setCurrentExercise(Exercise? nextExercise) {
    if (currentExercise != nextExercise) {
      endSet();
      currentExercise = nextExercise;
      setCount = _computeSetCount();
      state = _createState();
    }
  }

  /// Figure out the set count for the current exercise by looking at the
  /// current session and counting the sets for the [currentExercise].
  int _computeSetCount() {
    final session = ref.read(workoutSessionNotifierProvider);
    return session.maybeMap(
      (s) {
        return s.sets.fold(
                0,
                (int previousValue, element) => element.maybeMap(
                      (v) => v.exercise == currentExercise
                          ? previousValue + 1
                          : previousValue,
                      orElse: () => previousValue,
                    )) +
            1;
      },
      orElse: () => 1,
    );
  }

  /// Update the state using the current values
  WorkoutSetState _createState() {
    return WorkoutSetState(
        exercise: currentExercise, setNumber: setCount, reps: reps);
  }

  /// Complete the current set, recording it if there are any reps
  void endSet() {
    if (reps.isNotEmpty) {
      ref.read(workoutSessionNotifierProvider.notifier).addSet(_createState());
    }

    reps = [];
    setCount++; // Assume no change to the exercise
  }
}
