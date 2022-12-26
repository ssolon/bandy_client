import 'dart:async';

import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/effort/effort_state.dart';
import 'package:bandy_client/exercise/current/current_exercise_notifier.dart';
import 'package:bandy_client/exercise/exercise_dummys.dart';
import 'package:bandy_client/exercise/list/exercise_list_notifier.dart';
import 'package:bandy_client/exercise/list/exercise_list_state.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_notifier.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_state.dart';
import 'package:bandy_client/workout_session/current/workout_session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dummy device to make providers happy
final ScannedDevice d = ScannedDevice(deviceId: 'deviceId', name: 'testDevice');

/// Subclass notifier so we don't have to mock/hack the repCounter
class FakeRepCounterNotifier extends RepCounterNotifier {
  FakeRepCounterNotifier(Ref ref, ScannedDevice device) : super(ref, device);

  /// Report a rep explicitly
  // TODO Should this just be part of [RepCounterNotifier]?
  void notifyRep(int count, int maxValue) {
    state = RepCount(count, maxValue, Rep([]), EffortState.zero());
  }
}

final fakeRepCounterNotifierProvider =
    StateNotifierProvider.family<RepCounterNotifier, RepCount, ScannedDevice>(
        (ref, device) => FakeRepCounterNotifier(ref, device));

/// Exercises for testing

class MockExerciseListNotifier extends ExerciseListNotifier {
  @override
  FutureOr<ExerciseListState> build() {
    return ExerciseListState(items: [
      for (final e in dummyExercises.entries)
        ExerciseListItem(id: e.key, name: e.value.name)
    ]);
  }
}

void main() {
  test(
    "Exercise provider test",
    () async {
      final container = ProviderContainer(overrides: [
        exerciseListNotifierProvider
            .overrideWith(() => MockExerciseListNotifier()),
      ]);
      addTearDown(container.dispose);

      final v = container.read(exerciseListNotifierProvider);
      final exercisesData = v.whenOrNull(
        data: (items) => items,
        error: (error, stackTrace) => fail("Exercises fetch error=$error"),
      );
      expect(exercisesData, isNotNull, reason: 'Test exercises created');
      final exercises = exercisesData!.maybeWhen(
        (items) => items,
        orElse: () =>
            fail("ExercisesData invalid ${exercisesData.runtimeType}"),
      );
      expect(exercises, isNotEmpty, reason: 'Have test exercises');
      expect(
          exercises,
          contains(predicate(
            (ExerciseListItem p0) => p0.name == 'Chest Press',
          )));
    },
  );

  group('WorkoutSet tests', () {
    group('Integration Tests', () {
      // We use the same container for everything in this group

      final container = ProviderContainer(overrides: [
        repCounterStateProvider
            .overrideWithProvider((d) => fakeRepCounterNotifierProvider(d)),
      ]);
      late WorkoutSetState workoutSet;

      container.listen(workoutSetNotifierProvider(d),
          (prev, WorkoutSetState next) {
        workoutSet = next;
      });

      /// Utility function to add a rep
      void addRep(int count, int maxValue) async {
        (container.read(repCounterStateProvider(d).notifier)
                as FakeRepCounterNotifier)
            .notifyRep(count, maxValue);
      }

      test('Setup session', () async {
        // Need an active session for these tests
        expect(
            container.read(workoutSessionNotifierProvider).maybeMap(
                (value) => false,
                initial: (value) => true,
                orElse: () => false),
            isTrue,
            reason: 'Session starts at initial');

        container.read(workoutSessionNotifierProvider.notifier).start();
        await container.pump();

        expect(
            container
                .read(workoutSessionNotifierProvider)
                .maybeMap((value) => true, orElse: () => false),
            isTrue,
            reason: 'Session inProgress');

        // For some reason this read is needed but the pump works for subsequent
        // Maybe the notifier isn't initialized until something references it?
        workoutSet = container.read(workoutSetNotifierProvider(d));
      });

      test('Initial state values', () async {
        workoutSet.maybeMap(
            (value) => fail('WorkoutSet should start as Initial'),
            initial: (initial) {},
            orElse: () => fail(
                "WorkoutSet should start as initial ${workoutSet.runtimeType}"));

        // Create and check two reps
      });
      test('Add first rep', () async {
        addRep(1, 10);

        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
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
        addRep(2, 20);

        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
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
        addRep(1, 100);

        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
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
        addRep(1, 1000);
        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
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

      test('Add another rep to same exercise', () async {
        addRep(2, 2000);
        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
            expect(exercise?.id, dummyExerciseList[0].id,
                reason: 'Current exercise id');
            expect(setNumber, 1, reason: 'Still same set for exercise[0]');
            expect(reps.length, 2, reason: 'Added second rep');
            expect(reps[0].count, 1, reason: 'First rep count unchanged');
            expect(reps[0].maxValue, 1000, reason: 'First rep max unchanged');
            expect(reps[1].count, 2, reason: 'Second rep count');
          },
          orElse: () => fail(
              "Should still have valid WorkoutSetState.data ${workoutSet.runtimeType}"),
        );
      });

      test('Change exercise again', () async {
        container
            .read(currentExerciseNotifierProvider.notifier)
            .setExercise(dummyExerciseList[1]);
        addRep(1, 10);
        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
            expect(exercise?.id, dummyExerciseList[1].id,
                reason: 'Current exercise id');
            expect(setNumber, 1, reason: 'Exercise change resets set counter');
            expect(reps.length, 1, reason: 'Exercise change resets reps');
            expect(reps[0].count, 1,
                reason: 'Exercise change resets rep count');
            expect(reps[0].maxValue, 10);
          },
          orElse: () => fail('Should still have valid WorkoutSetState.data'),
        );
      });

      test('Back to previous exercise', () async {
        container
            .read(currentExerciseNotifierProvider.notifier)
            .setExercise(dummyExerciseList[0]);

        addRep(1, 100);
        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
            expect(exercise?.id, dummyExerciseList[0].id,
                reason: 'Current exercise id');
            expect(setNumber, 2,
                reason: 'Exercise change back continues set count');
            expect(reps.length, 1, reason: 'Exercise change resets reps');
            expect(reps[0].count, 1,
                reason: 'Exercise change resets rep count');
            expect(reps[0].maxValue, 100, reason: 'maxValue');
          },
          orElse: () => fail('Should still have valid WorkoutSetState.data'),
        );
      });
      test('One more rep for good measure', () async {
        addRep(2, 200);
        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
            expect(exercise?.id, dummyExerciseList[0].id,
                reason: 'Current exercise id');
            expect(setNumber, 2,
                reason: 'Exercise change back continues set count');
            expect(reps.length, 2, reason: 'Added a rep');
            expect(reps[0].count, 1, reason: 'Unchanged first rep count');
            expect(reps[0].maxValue, 100, reason: 'Unchanged first rep max');
            expect(reps[1].count, 2, reason: 'Second rep count');
            expect(reps[1].maxValue, 200, reason: 'Second rep max');
          },
          orElse: () => fail('Should still have valid WorkoutSetState.data'),
        );
      });

      test('Back to no exercise', () async {
        container
            .read(currentExerciseNotifierProvider.notifier)
            .setExercise(null);

        await container.pump();

        addRep(1, 11);
        await container.pump();

        workoutSet.maybeWhen(
          (exercise, setNumber, effort, reps) {
            expect(exercise?.id, isNull, reason: 'No exericse');
            expect(setNumber, 3, reason: 'Third set of no exercise');
            expect(reps.length, 1, reason: 'First rep');
            expect(reps[0].count, 1, reason: 'First rep');
            expect(reps[0].maxValue, 11, reason: 'First rep maxValue');
          },
          orElse: () => fail('Should still have valid WorkoutSetState.data'),
        );
      });
    });
  });
}
