import 'dart:async';

import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'value_display.dart';

class DeviceDisplayWidget extends ConsumerWidget {
  final ScannedDevice scannedDevice;

  const DeviceDisplayWidget(this.scannedDevice, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectionProvider(scannedDevice));

    // We only care about handling disconnected and erros
    connectionState.maybeMap<int>(null,
        initial: (arg) => 0, // Doesn't mattmer
        disconnected: (arg) => _handleDisconnected(context, ref),
        error: (error) => _handleError(context, error.message),
        orElse: () => 0); // Don't care

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("${scannedDevice.name} (${scannedDevice.deviceId})"),
        TextButton(
          onPressed: () => _doDisconnect(ref),
          child: const Text("Disconnect"),
        )
      ]),
      ValueDisplayWidget(scannedDevice),
    ]);
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
    // TODO We should ignore the GAT errors which seem to happen when
    // disconnected and probably several others but for now we'll just
    // display them until we can figure out which to ignore.
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
