import 'dart:async';
import 'dart:typed_data';

import 'package:bandy_client/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import '../../scanner/logic/scanned_device.dart';
import 'device_state.dart';

part 'device_state_notifier.dart';

/// Provider to use the DeviceStateNotifier
final deviceNotifierProvider =
    StateNotifierProvider.family<DeviceNotifier, DeviceState, ScannedDevice>(
  (ref, scannedDevice) => DeviceNotifier(scannedDevice),
);

/// Repositories Providers
/// TODO: Create Repositories Providers

/// Use Cases Providers
/// TODO: Create Use Cases Providers