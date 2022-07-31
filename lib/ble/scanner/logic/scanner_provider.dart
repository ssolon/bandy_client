import 'dart:async';

import 'package:bandy_client/main.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';

import 'scanned_device.dart';
import 'scanner_state.dart';

part 'scanner_state_notifier.dart';

/// Provider to scan devices
final scannerStateNotifierProvider =
    StateNotifierProvider.autoDispose<ScannerStateNotifier, ScannerState>(
        (ref) => ScannerStateNotifier());


/// Repositories Providers
/// TODO: Create Repositories Providers

/// Use Cases Providers
/// TODO: Create Use Cases Providers