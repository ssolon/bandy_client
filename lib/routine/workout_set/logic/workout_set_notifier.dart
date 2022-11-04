import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'workout_set_state.dart';

part 'workout_set_notifier.g.dart';

@riverpod
class WorkoutSetNotifier extends _$WorkoutSetNotifier {
  late final ScannedDevice device;
  List<RepCount> reps = [];

  @override
  WorkoutSetState build(ScannedDevice d) {
    device = d;
    ref.listen(repCounterStateProvider(device),
        (RepCount? previous, RepCount next) {
      if (next.count == 0) {
        // Ignore initial
        // TODO Use Rep to indicate?
      } else {
        reps.add(next);
        state = WorkoutSetState(reps: reps);
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

  void endSet() {
    reps = [];
    // TODO Handle multiple sets
  }
}
