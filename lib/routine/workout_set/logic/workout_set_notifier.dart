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
      reps.add(next);
      state = WorkoutSetState(reps: reps);
    });
    return const WorkoutSetState.initial();
  }
}
