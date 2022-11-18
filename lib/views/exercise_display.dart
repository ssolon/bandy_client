import 'package:bandy_client/exercise/current/current_exercise_notifier.dart';
import 'package:bandy_client/exercise/list/exercise_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../exercise/list/exercise_list_state.dart';

class ExerciseDisplayWidget extends ConsumerWidget {
  const ExerciseDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(exerciseListNotifierProvider);
    final currentExercise = ref.watch(currentExerciseNotifierProvider);

    final List<ExerciseListItem> exercises =
        value.maybeWhen((items) => items, orElse: () => []);

    return DropdownButton<UuidValue>(
      hint: exercises.isNotEmpty
          ? const Text('Select an exercise')
          : const Text('No exercises available'),
      onChanged: (value) {
        ref
            .read(currentExerciseNotifierProvider.notifier)
            .setExerciseById(value);
      },
      value: currentExercise.whenOrNull((e) => e.id),
      items: [
        for (final e in exercises)
          DropdownMenuItem(value: e.id, child: Text(e.name)),
      ],
    );
  }
}
