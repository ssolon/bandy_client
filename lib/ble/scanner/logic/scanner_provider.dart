import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:quick_blue/quick_blue.dart';

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