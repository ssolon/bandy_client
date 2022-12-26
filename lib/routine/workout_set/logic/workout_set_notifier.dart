import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/effort/effort_state.dart';
import 'package:bandy_client/exercise/current/current_exercise_notifier.dart';
import 'package:bandy_client/exercise/exercise.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:bandy_client/workout_session/current/workout_session_notifier.dart';
import 'package:bandy_client/workout_session/current/workout_session_state.dart';
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
  EffortState effort = EffortState(concentric: 0.0, eccentric: 0.0, total: 0.0);

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
        state = addRep(next);
      }
    });

    ref.listen(
      workoutSessionNotifierProvider,
      (WorkoutSessionState? previous, WorkoutSessionState next) {
        next.maybeMap(
          (value) => null, // ignore in progress
          initial: (value) => reset(), // TODO Will we get this when we need to?
          finishing: (value) => endSet(), // clear out anything left over
          orElse: () {}, // ignore anything else
        );
      },
    );

    // End set on button click
    // TODO Have rep counter feed back an endSet?
    ref.listen(
      button1ClickedProvider(device),
      (previous, next) => endSet(),
    );
    return const WorkoutSetState.initial();
  }

  /// Add [rep] to this set
  WorkoutSetState addRep(RepCount rep) {
    reps.add(rep);

    // Update effort
    effort = effort.update(rep.effort);

    return _createState();
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
        exercise: currentExercise,
        setNumber: setCount,
        effort: effort,
        reps: reps);
  }

  /// Reset to a clean state throwing away anything that came before.
  void reset() {
    reps = [];
    setCount = 1;

    state = _createState();
  }

  /// Complete the current set, recording it if there are any reps
  void endSet() {
    if (reps.isNotEmpty) {
      ref.read(workoutSessionNotifierProvider.notifier).addSet(_createState());
    }

    // Prepare for next set (if any)
    ref.read(repCounterStateProvider(device).notifier).reset();
    reps = [];
    effort = EffortState.zero();
    setCount++; // Assume no change to the exercise

    state = _createState();
  }
}
