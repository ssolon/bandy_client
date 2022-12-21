import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/effort/effort_computer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'effort_state.dart';
part 'effort_notifier.g.dart';

@riverpod
class EffortNotifier extends _$EffortNotifier {
  @override
  double build(ScannedDevice device, {int minDeltaMillis = 100}) {
    ref.listen(deviceNotifierProvider(device),
        (DeviceState? previous, DeviceState next) {
      if (previous == null) {
        return; // need two points to compute an error
      }

      // We only care about moving so ignore long intervals
      final instant1 = previous.mapOrNull((value) => value.instant);
      final instant2 = next.mapOrNull((value) => value.instant);

      if (instant1 == null || instant2 == null) {
        return; // Ignore no data
      }

      if (instant2.when.difference(instant1.when).abs().inMilliseconds >
          minDeltaMillis) {
        return; // Too long time has passed
      }

      state = EffortComputer.compute(instant1, instant2);
    });

    return 0.0;
  }
}
