import 'package:bandy_client/timers/workout_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Workout/routine/exercise display

class WorkoutWidget extends ConsumerWidget {
  final String routineName;

  const WorkoutWidget({super.key, this.routineName = 'Workout'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              routineName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const TimerDisplayWidget(),
        ],
      ),
    );
  }
}

class TimerDisplayWidget extends ConsumerWidget {
  const TimerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(workoutTimerNotifierProvider);

    return Expanded(
      child: GestureDetector(
        onLongPress: () =>
            ref.read(workoutTimerNotifierProvider.notifier).reset(),
        child: Text(
          formatTimer(value),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}

String formatTimer(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  final seconds = d.inSeconds.remainder(60);

  return hours > 0
      ? ("$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}")
      : minutes > 0
          ? ("${minutes.toString()}:${seconds.toString().padLeft(2, '0')}")
          : seconds.toString();
}
