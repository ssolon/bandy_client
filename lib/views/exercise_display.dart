import 'package:bandy_client/exercise/current/current_exercise_notifier.dart';
import 'package:bandy_client/exercise/list/exercise_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../exercise/list/exercise_list_state.dart';

final nullExerciseId = UuidValue(Uuid.NAMESPACE_NIL);

class ExerciseDisplayWidget extends ConsumerWidget {
  const ExerciseDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(exerciseListNotifierProvider);
    final currentExercise = ref.watch(currentExerciseNotifierProvider);

    final Either<Text, List<ExerciseListItem>> result = value.when(
      data: (items) => items.maybeWhen((items) => Either.right(items),
          orElse: () => Either.right([])),
      error: (error, stack) =>
          Either.left(Text("Failed to load exercises:$error")),
      loading: () => Either.left(const Text("Fetching exercises")),
    );

    return result.match(
      identity,
      (exercises) => DropdownButton<UuidValue>(
        hint: exercises.isNotEmpty
            ? const Text('Select an exercise')
            : const Text('No exercises available'),
        onChanged: (value) {
          ref
              .read(currentExerciseNotifierProvider.notifier)
              .setExerciseById(value == nullExerciseId ? null : value);
        },
        value: currentExercise.whenOrNull((e) => e.id),
        items: [
          DropdownMenuItem(
              value: nullExerciseId,
              child: const Text('None',
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic))),
          for (final e in exercises)
            DropdownMenuItem(value: e.id, child: Text(e.name)),
        ],
      ),
    );
  }
}
