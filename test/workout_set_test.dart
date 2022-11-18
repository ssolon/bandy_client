import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/exercise/current/current_exercise_notifier.dart';
import 'package:bandy_client/exercise/exercise_dummys.dart';
import 'package:bandy_client/exercise/list/exercise_list_notifier.dart';
import 'package:bandy_client/exercise/list/exercise_list_state.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_notifier.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dummy device to make providers happy
final ScannedDevice d = ScannedDevice(deviceId: 'deviceId', name: 'testDevice');

/// Subclass notifier so we don't have to mock/hack the repCounter
class FakeRepCounterNotifier extends RepCounterNotifier {
  FakeRepCounterNotifier(Ref ref, ScannedDevice device) : super(ref, device);

  /// Report a rep explicitly
  // TODO This should just be part of [RepCounterNotifier]?
  void notifyRep(int count, int maxValue) {
    state = RepCount(count, maxValue);
  }
}

final fakeRepCounterNotifierProvider =
    StateNotifierProvider.family<RepCounterNotifier, RepCount, ScannedDevice>(
        (ref, device) => FakeRepCounterNotifier(ref, device));

/// Exercises for testing

void main() {
  test(
    "Exercise provider test",
    () async {
      final container = ProviderContainer();

      final exercises = container
          .read(exerciseListNotifierProvider)
          .whenOrNull((items) => items);
      expect(exercises, isNotNull, reason: 'Test exercises created');
      expect(exercises, isNotEmpty, reason: 'Have test exercises');
      expect(
          exercises,
          contains(predicate(
            (ExerciseListItem p0) => p0.name == 'Chest Press',
          )));
    },
  );

  group('WorkoutSet tests', () {
    group('No exercise', () {
      // We use the same container for everything in this group
      // Violates independence of unit tests -- but we always do

      final container = ProviderContainer(overrides: [
        repCounterStateProvider
            .overrideWithProvider((d) => fakeRepCounterNotifierProvider(d)),
      ]);
      late WorkoutSetState workoutSet;

      container.listen(workoutSetNotifierProvider(d),
          (prev, WorkoutSetState next) {
        workoutSet = next;
      });

      // For some reason this read is needed but the pump works for subsequent
      // Maybe the notifier isn't initialized until something references it?
      workoutSet = container.read(workoutSetNotifierProvider(d));

      test('Initial state values', () async {
        workoutSet.maybeMap(
            (value) => fail('WorkoutSet should start as Initial'),
            initial: (initial) {},
            orElse: () => fail(
                "WorkoutSet should start as initial ${workoutSet.runtimeType}"));

        // Create and check two reps
      });
      test('Add first rep', () async {
        (container.read(repCounterStateProvider(d).notifier)
                as FakeRepCounterNotifier)
            .notifyRep(1, 10);

        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, reps) {
            expect(exercise, isNull, reason: 'Initial exercise is null');
            expect(setNumber, 1);
            expect(reps, hasLength(1));
            expect(reps[0].count, 1);
            expect(reps[0].maxValue, 10);
          },
          orElse: () => fail('First rep should create Data'),
        );
      });

      test('Add second rep', () async {
        (container.read(repCounterStateProvider(d).notifier)
                as FakeRepCounterNotifier)
            .notifyRep(2, 20);

        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, reps) {
            expect(exercise, isNull, reason: 'Initial exercise is null');
            expect(setNumber, 1);
            expect(reps, hasLength(2));
            expect(reps[0].count, 1);
            expect(reps[0].maxValue, 10);
            expect(reps[1].count, 2);
            expect(reps[1].maxValue, 20);
          },
          orElse: () => fail('Second rep should have Data'),
        );
      });

      test('Trigger second set first rep', () async {
        container.read(workoutSetNotifierProvider(d).notifier).endSet();
        await container.pump();

        // For now we don't switch set until we get the next rep
        (container.read(repCounterStateProvider(d).notifier)
                as FakeRepCounterNotifier)
            .notifyRep(1, 100);

        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, reps) {
            expect(exercise, isNull, reason: 'Initial exercise is null');
            expect(setNumber, 2);
            expect(reps, hasLength(1));
            expect(reps[0].count, 1);
            expect(reps[0].maxValue, 100);
          },
          orElse: () => fail('First rep should create Data'),
        );
      });

      test('Set a current exercise', () async {
        container
            .read(currentExerciseNotifierProvider.notifier)
            .setExercise(dummyExerciseList[0]);

        // For now we don't switch set until we get the next rep
        (container.read(repCounterStateProvider(d).notifier)
                as FakeRepCounterNotifier)
            .notifyRep(1, 1000);

        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, reps) {
            expect(exercise?.id, dummyExerciseList[0].id,
                reason: 'Current exercise id');
            expect(setNumber, 1, reason: 'Exercise change resets set counter');
            expect(reps.length, 1, reason: 'Exercise change resets reps');
            expect(reps[0].count, 1,
                reason: 'Exercise change resets rep count');
            expect(reps[0].maxValue, 1000);
          },
          orElse: () => fail('Should still have valid WorkoutSetState.data'),
        );
      });
    });
  });
}
