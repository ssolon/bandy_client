import 'dart:async';
import 'dart:typed_data';

import 'package:bandy_client/main.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import '../../scanner/logic/scanned_device.dart';
import 'device_state.dart';

part 'device_state_notifier.dart';
part 'connection_state_notifier.dart';
part 'value_state_notifier.dart';
part 'button1_state_notifier.dart';

/// Provider to use the DeviceStateNotifier
final deviceNotifierProvider =
    StateNotifierProvider.family<DeviceNotifier, DeviceState, ScannedDevice>(
  (ref, scannedDevice) => DeviceNotifier(scannedDevice),
);

/// Provider with connection state
final connectionProvider = StateNotifierProvider.family<ConnectionNotifier,
        DeviceState, ScannedDevice>(
    (ref, scannedDevice) => ConnectionNotifier(ref, scannedDevice));

/// Provider to provide only values that change
final valueProvider =
    StateNotifierProvider.family<ValueNotifier, int, ScannedDevice>(
        (ref, scannedDevice) => ValueNotifier(ref, scannedDevice));

/// Provider for button clicks
final button1ClickedProvider =
    StateNotifierProvider.family<Button1Notifier, int, ScannedDevice>(
        (ref, scannedDevice) => Button1Notifier(ref, scannedDevice));

/// Repositories Providers
/// TODO: Create Repositories Providers

/// Use Cases Providers
/// TODO: Create Use Cases Providers