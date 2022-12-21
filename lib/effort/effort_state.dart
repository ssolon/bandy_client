import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:bandy_client/effort/effort_computer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'effort_state.freezed.dart';
part 'effort_state.g.dart';

@freezed
class EffortState with _$EffortState {
  EffortState._();

  factory EffortState(
      {required double concentric,
      required double eccentric,
      required double total}) = _EffortState;

  factory EffortState.zero() {
    return EffortState(concentric: 0.0, eccentric: 0.0, total: 0.0);
  }

  /// Create an [EffortState] from [instants].
  factory EffortState.of(List<Instant> instants) {
    double concentric = 0.0;
    double eccentric = 0.0;
    bool first = true;

    late Instant prevInstant;

    for (final i in instants) {
      if (first) {
        first = false;
      } else {
        final e = EffortComputer.compute(prevInstant, i);
        if (e > 0) {
          concentric += e;
        } else {
          eccentric += e.abs();
        }
      }

      prevInstant = i;
    }

    return EffortState(
        concentric: concentric,
        eccentric: eccentric,
        total: concentric + eccentric);
  }

  EffortState update(EffortState newValues) {
    return EffortState(
        concentric: concentric + newValues.concentric,
        eccentric: eccentric + newValues.eccentric,
        total: total + newValues.total);
  }

  factory EffortState.fromJson(Map<String, dynamic> json) =>
      _$EffortStateFromJson(json);
}
