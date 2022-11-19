import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/exercise/exercise.dart';
import 'package:bandy_client/views/rep_list_display.dart';
import 'package:bandy_client/workout_session/workout_session_notifier.dart';
import 'package:bandy_client/workout_session/workout_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routine/workout_set/logic/workout_set_notifier.dart';
import '../routine/workout_set/logic/workout_set_state.dart';

/// Show current set and all sets in the session (if any)
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
    final workoutSession = ref.watch(workoutSessionNotifierProvider);

    return workoutSession.maybeWhen(
      (starting, sets) {
        // session is active
        return WorkoutSetDisplay(workoutSet, workoutSession, widget.device);
      },
      error: (message) => Text("Error: $message"),
      orElse: () => Text("Start session to record",
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

/// Display a single workout set
class WorkoutSetDisplay extends StatelessWidget {
  final WorkoutSetState workoutSet;
  final WorkoutSessionState workoutSession;
  final ScannedDevice device;

  const WorkoutSetDisplay(this.workoutSet, this.workoutSession, this.device,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentSet = workoutSet.maybeMap((set) => set, orElse: () => null);
    final historicSets = workoutSession.maybeWhen((starting, sets) => sets,
        orElse: () => <WorkoutSetState>[]);

    return Expanded(
      child: ListView(
        children: [
          if (currentSet != null) currentSetDisplay(currentSet, context),
          for (final s in historicSets.reversed) historySetDisplay(s, context),
        ],
      ),
    );
  }

  /// Create a name to display for the set based on the [exercise], if any
  String _setName(Exercise? exercise, int setNumber) {
    return "${exercise?.name ?? ''}#$setNumber";
  }

  /// Display the current set
  Widget currentSetDisplay(currentSet, context) {
    return Column(
      children: [
        setHeader(currentSet, context),
        RepListWidget(device),
      ],
    );
  }

  /// Display a historic set
  Widget historySetDisplay(historySet, context) {
    return setHeader(historySet, context);
  }

  /// Generate a header for a set
  Widget setHeader(theSet, context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey,
      child: Row(
        children: [
          Expanded(
            child: Text(_setName(theSet.exercise, theSet.setNumber),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          Expanded(
            child: Text(
              "Effort", //"10 (5+5)",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${theSet.reps.length}",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
