import 'dart:math';

import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loggy/loggy.dart';

import '../ble/scanner/logic/scanned_device.dart';

part 'rep_counter.g.dart';

/// A Rep is a list of instants.
@JsonSerializable()
class Rep {
  final List<Instant> instants;

  Rep(this.instants); // : instants = List.unmodifiable(i);

  int get maxResistance => instants.fold(
      instants.isEmpty ? 0 : instants[0].reading,
      (previousValue, element) => max(previousValue, element.reading));

  factory Rep.fromJson(Map<String, dynamic> json) => _$RepFromJson(json);

  Map<String, dynamic> toJson() => _$RepToJson(this);
}

@JsonSerializable()
class RepCount {
  final int count;
  final int maxValue;
  final Rep reps;

  RepCount(this.count, this.maxValue, this.reps);

  RepCount.zero()
      : count = 0,
        maxValue = 0,
        reps = Rep([]);

  factory RepCount.fromJson(Map<String, dynamic> json) =>
      _$RepCountFromJson(json);
  Map<String, dynamic> toJson() => _$RepCountToJson(this);
}

final repCounterStateProvider =
    StateNotifierProvider.family<RepCounterNotifier, RepCount, ScannedDevice>(
        (ref, scannedDevice) => RepCounterNotifier(ref, scannedDevice));

/// Hysteresis percentage to be considered a new rep to reset
const repHysteresis = 0.10; // 10%

// TODO Not used but maybe we should?
/// Minimum amount for first minimum (to reduce initial noise)
const minHysteresis = 2;

/// Counts and reports on the reps
///
class RepCounterNotifier extends StateNotifier<RepCount> with UiLoggy {
  InstantHandler handler = InstantHandler();

  RepCounterNotifier(Ref ref, ScannedDevice device) : super(RepCount.zero()) {
    ref.listen(valueProvider(device), (Instant? previous, Instant next) {
      final report = handler.add(next);
      if (report != null) {
        state = report;
      }
    });
  }

  void reset() {
    handler = InstantHandler();
  }
}

/// Hold a reference to an Instant in a list of instants.
class StoredInstant {
  final List<Instant> _instants;
  late final int index;

  /// Add a reference to an Instant at [index] of [_instants].
  /// If [index] is null/missing using the top of [_instants].
  StoredInstant(this._instants, [int? theIndex]) {
    index = theIndex ?? _instants.length - 1;
  }

  Instant get instant => _instants[index];

  int get reading => instant.reading;
}

enum Inflection { turnDown, turnUp, continues }

/// Keep track of instants and which are part of reps
class InstantHandler {
  /// How much change do we need for an inflection point
  double inflectionSignifier;
  final List<Instant> _instants = [];

  InstantHandler([this.inflectionSignifier = 0.1]);
  int get lastReading => _instants.last.reading;
  StoredInstant saveTop() => StoredInstant(_instants);

  bool reported = false;
  int repCount = 0;

  StoredInstant? _minInstant;
  StoredInstant? _repStartInstant;

  int _maxValue = 0;
  Inflection lastTurn = Inflection.continues;

  bool get _goingDown => lastTurn == Inflection.turnDown;
  // Not currently used but retaining for doc purposes
  // bool get _goingUp => lastTurn == Inflection.turnUp;

  /// Check if we should start the next rep
  bool get _nextRepStart =>
      !reported &&
      (
          // If this is the first rep, might as well report (nothing)
          _repStartInstant == null ||
              (_repStartInstant!.reading * repHysteresis) <
                  (lastReading - (_minInstant?.reading ?? 0)));

  /// Update [_minValue] from the top instant.
  void _updateMinValue() {
    final less = _minInstant?.reading == null
        ? true
        : lastReading < _minInstant!.reading;

    if (less) {
      _minInstant = saveTop();
    }
  }

  /// Add an instant returning a [RepCount] for each rep detected
  RepCount? add(Instant theInstant) {
    // Shortcut first instant

    if (_instants.isEmpty) {
      _instants.add(theInstant);
      return null;
    }

    // ignore duplicate values (would this happen?)

    if (theInstant.reading == _instants.last.reading) {
      return null;
    }

    // Stow new reading

    _instants.add(theInstant);
    _maxValue = max(_maxValue, lastReading);

    final inflection = inflectionPoint();
    switch (inflection) {
      case Inflection.continues: // Keep on truckin
        if (_goingDown) {
          _updateMinValue();
        } else {
          if (_nextRepStart) {
            return reportRep();
          }
        }
        return null; // keep on truckin

      case Inflection.turnDown:
        reported = false; // so we'll report this rep
        lastTurn = inflection;
        _updateMinValue();
        return null;

      case Inflection.turnUp:
        lastTurn = inflection;
        return _nextRepStart ? reportRep() : null;
    }
  }

  /// Create a RepCount to report a completed rep based on the current values
  /// by handling all the bookeeping and creating and returning the
  /// state object.
  RepCount? reportRep() {
    // only report once
    if (reported) {
      return null;
    }

    reported = true;

    late final RepCount? result;

    // If we've just started -- there's nothing to report
    if (_repStartInstant == null) {
      result = null;
    } else {
      // Create the state object
      final repsStartIndex = _repStartInstant?.index ?? 0;
      final repsEndIndex = (_minInstant?.index ?? 0);
      final reps = List<Instant>.from(
          _instants.getRange(repsStartIndex, repsEndIndex + 1));
      result = RepCount(++repCount, _maxValue, Rep(reps));
    }

    // Setup for this to be the next rep

    _repStartInstant = _minInstant ?? StoredInstant(_instants, 0);
    _minInstant = null;
    _maxValue = 0;
    return result;
  }

  /// Does the top value represent an inflection point?
  Inflection inflectionPoint() {
    int l = _instants.length - 1;

    if (l < 2) {
      return Inflection.continues; // not enought points
    }

    final deltaTop = _instants[l].reading - _instants[l - 1].reading;
    final deltaNext = _instants[l - 1].reading - _instants[l - 2].reading;

    return deltaTop.sign == deltaNext.sign
        ? Inflection.continues
        : deltaTop.sign > 0
            ? Inflection.turnUp
            : Inflection.turnDown;
  }

  // TODO Not currently used but maybe it should be to make the rep detection
  // more robust. Leaving it here for now.
  /// Look backwards and return the index of the last inflection point
  int lastMinInflectionPoint() {
    var reverseIndex = _instants.length;
    var minValue = _instants.last.reading;
    var minIndex = _instants.length - 1;

    while (--reverseIndex > 0) {
      final next = _instants[reverseIndex].reading;
      final delta = next - minValue;

      if (delta <= 0) {
        // Maybe min
        minIndex = reverseIndex;
        minValue = next;
      } else {
        // greater. Inflection point?
        if (delta > minValue * inflectionSignifier) {
          return minIndex;
        }
      }
    }

    // If we run off the bottom, use the first

    return 0;
  }

  List<Instant> range(int from, int to) {
    return _instants.sublist(from, to);
  }
}
