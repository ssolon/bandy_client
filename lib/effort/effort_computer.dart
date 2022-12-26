import 'dart:math';

import 'package:bandy_client/ble/device/logic/device_state.dart';

class EffortComputer {
  /// Return the effort between [i1] and [i2]
  static double compute(Instant i1, Instant i2) {
    final dt = (i2.when.difference(i1.when).inMilliseconds).abs();
    final dv = i2.reading - i1.reading;
    final dmin = (min(i2.reading, i1.reading));

    final e = (dmin * dt * dv.sign) + (dv * dt / 2.0);
    return (e / 1000).roundToDouble();
  }
}
