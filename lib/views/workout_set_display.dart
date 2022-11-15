import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/exercise/current/current_exercise_notifier.dart';
import 'package:bandy_client/views/rep_list_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routine/workout_set/logic/workout_set_notifier.dart';
import '../routine/workout_set/logic/workout_set_state.dart';

class WorkoutSetsWidget extends ConsumerStatefulWidget {
  final ScannedDevice device;

  const WorkoutSetsWidget(this.device, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WorkoutSetsWidgetState();
}

class _WorkoutSetsWidgetState extends ConsumerState<WorkoutSetsWidget> {
  @override
  Widget build(BuildContext context) {
    final workoutSet = ref.watch(workoutSetNotifierProvider(widget.device));

    return WorkoutSetDisplay(workoutSet, widget.device);
  }
}

/// Display a single workout set
class WorkoutSetDisplay extends StatelessWidget {
  final WorkoutSetState workoutSet;
  final ScannedDevice device;

  const WorkoutSetDisplay(this.workoutSet, this.device, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return workoutSet.maybeWhen(
      (setName, reps) {
        return Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey,
                    child: Text(setName,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  RepListWidget(device),
                ],
              ),
            ],
          ),
        );
      },
      error: (message) => Text("Error: $message"),
      orElse: () => const Text("No workout session"),
    );
  }
}
