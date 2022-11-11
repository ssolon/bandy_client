import 'package:bandy_client/timers/workout_timer.dart';
import 'package:bandy_client/views/exercise_display.dart';
import 'package:bandy_client/workout_session/workout_session_notifier.dart';
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
      child: Column(
        children: [
          Row(
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
          const ExerciseDisplayWidget(),
        ],
      ),
    );
  }
}

/// If a session hasn't started display start button otherwise show the timer.
class TimerDisplayWidget extends ConsumerWidget {
  const TimerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(workoutSessionNotifierProvider);
    final duration = ref.watch(workoutTimerNotifierProvider);

    return Expanded(
      child: session.maybeMap(
        (sessionData) => Row(
          children: [
            ElevatedButton(
                onPressed: () =>
                    ref.read(workoutSessionNotifierProvider.notifier).finish(),
                child: const Text('Finish')),
            Expanded(child: _timer(duration, ref)),
          ],
        ),
        completed: (value) => Row(children: [
          ElevatedButton(
              onPressed: () =>
                  ref.read(workoutSessionNotifierProvider.notifier).initial(),
              child: const Text('New Session')),
        ]),
        // Show start button to start a new session
        initial: (value) => ElevatedButton(
            child: const Text('Start Session'),
            onPressed: () =>
                ref.read(workoutSessionNotifierProvider.notifier).start()),
        error: (value) => Text("ERROR: ${value.message}"), // TODO better
        orElse: () => Text("ERROR: Wrong session state ${session.runtimeType}"),
      ),
    );
  }

  _timer(duration, ref) {
    return GestureDetector(
      onLongPress: () =>
          ref.read(workoutTimerNotifierProvider.notifier).reset(),
      child: Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        message: 'Long press to reset timer',
        child: Text(
          formatTimer(duration),
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
