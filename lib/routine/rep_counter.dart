import 'dart:collection';
import 'dart:math';

import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';

import '../ble/scanner/logic/scanned_device.dart';

class RepCount {
  final int count;
  final int maxValue;

  RepCount(this.count, this.maxValue);
  const RepCount.zero()
      : count = 0,
        maxValue = 0;
}

final repCounterStateProvider =
    StateNotifierProvider.family<RepCounterNotifier, RepCount, ScannedDevice>(
        (ref, scannedDevice) => RepCounterNotifier(ref, scannedDevice));

/// Percentage of [maxValue] to be considered a rep
const repMaxValuePercentage = 0.50; // 24%

/// Hysteresis percentage to be considered a new rep to reset
const repHysteresis = 0.10; // 10%

/// Counts and reports on the reps
///
/// When the value falls to [repMaxValuePercentage] of the maximum value we've
/// seen we count a rep.
///
class RepCounterNotifier extends StateNotifier<RepCount> with UiLoggy {
  int maxValue = 0;
  int count = 0;

  int reportedValue = 0;
  bool reported = false;

  RepCounterNotifier(Ref ref, ScannedDevice device)
      : super(const RepCount.zero()) {
    ref.listen(valueProvider(device), (Instant? previous, Instant next) {
      final goingUp = next.reading > (previous?.reading ?? 0);

      if (goingUp) {
        // Going up -- just keep track
        maxValue = max(maxValue, next.reading);

        // Introduce some hysteresis on the way up for reset
        if (reported) {
          if (next.reading > reportedValue * repHysteresis) {
            // reset
            reported = false;
            maxValue = next.reading;
          }
        }
      }

      if (!goingUp &&
          !reported &&
          next.reading < maxValue * repMaxValuePercentage) {
        // going down and crossed breakpoint
        reportedValue = next.reading;
        reported = true;
        state = RepCount(++count, maxValue); // notify
      }
    });
  }

  void reset() {
    count = 0;
    state = const RepCount.zero();
  }
}
