import 'dart:async';

import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceDisplayWidget extends ConsumerWidget {
  final ScannedDevice scannedDevice;

  const DeviceDisplayWidget(this.scannedDevice, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(deviceNotifierProvider(scannedDevice));

    // Get a value to be displayed -- non-value states just use zero

    final newReading = device.map<int>((value) => value.reading,
        initial: (arg) => 0,
        connecting: (value) => _handleConnecting(context, ref),
        connected: (arg) => _handleConnected(context, ref),
        disconnected: (arg) => _handleDisconnected(context, ref),
        error: (error) => _handleError(context, error.message));

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("${scannedDevice.name} (${scannedDevice.deviceId})"),
        TextButton(
          onPressed: () => _doDisconnect(ref),
          child: const Text("Disconnect"),
        )
      ]),
      _updateValue(context, newReading),
    ]);
  }

  Widget _updateValue(BuildContext context, int reading) {
    return Center(
        child: Text(
      "$reading",
      style: Theme.of(context)
          .textTheme
          .displayLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    ));
  }

  int _handleConnecting(BuildContext context, WidgetRef ref) {
    //TODO Handler somewhere else?
    return 0;
  }

  int _handleConnected(BuildContext context, WidgetRef ref) {
    return 0;
  }

  int _handleDisconnected(BuildContext context, WidgetRef ref) {
    Timer.run(() => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            actions: [
              ConnectButton(scannedDevice, ref),
            ],
            title: Text("Disconnected from ${scannedDevice.name}"),
          ),
        ));

    return 0;
  }

  int _handleError(BuildContext context, String? message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text("Error: ${message ?? "Unknown error"}"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  )
                ]));

    return 0;
  }

  void _doDisconnect(WidgetRef ref) {
    ref.read(deviceNotifierProvider(scannedDevice).notifier).disconnect();
  }
}

class ConnectButton extends ConsumerWidget {
  final ScannedDevice scannedDevice;
  final WidgetRef ref;

  const ConnectButton(this.scannedDevice, this.ref, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<DeviceState>(deviceNotifierProvider(scannedDevice),
        (prev, next) {
      next.mapOrNull((value) => null,
          connected: ((value) => Navigator.pop(context)));
    });

    return TextButton(
      onPressed: () => _doConnect(context),
      child: const Text("Connect"),
    );
  }

  void _doConnect(context) {
    ref.read(deviceNotifierProvider(scannedDevice).notifier).connect();
  }
}
