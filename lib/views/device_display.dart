import 'dart:async';

import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';

class DeviceDisplayWidget extends ConsumerWidget {
  final ScannedDevice scannedDevice;

  const DeviceDisplayWidget(this.scannedDevice, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(deviceNotifierProvider(scannedDevice));

    // Get a value to be displayed -- non-value states just use zero

    final newReading = device.map<double>((value) => value.reading,
        initial: (arg) => 0.0,
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

  Widget _updateValue(BuildContext context, double reading) {
    return Center(
        child: Text(
      "${reading.round()}",
      style: Theme.of(context)
          .textTheme
          .displayLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    ));
  }

  double _handleConnected(BuildContext context, WidgetRef ref) {
    return 0.0;
  }

  double _handleDisconnected(BuildContext context, WidgetRef ref) {
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

    return 0.0;
  }

  double _handleError(BuildContext context, String? message) {
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

    return 0.0;
  }

  void _doConnect(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
  }

  void _doDisconnect(WidgetRef ref) {
    ref.read(deviceNotifierProvider(scannedDevice).notifier).disconnect();
  }
}

class ConnectionWidget extends ConsumerStatefulWidget {
  final ScannedDevice scannedDevice;
  const ConnectionWidget(this.scannedDevice, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectionWidgetState();
}

class _ConnectionWidgetState extends ConsumerState<ConnectionWidget> {
  DeviceState? currentDeviceState;

  @override
  Widget build(BuildContext context) {
    final deviceState = ref.watch(deviceNotifierProvider(widget.scannedDevice));

    // We only care about connection state transitions so we ignore everything
    // else and just keep the connection states.

    currentDeviceState = deviceState.map((value) => currentDeviceState,
        initial: (arg) => currentDeviceState,
        connected: (connectedState) => connectedState,
        disconnected: (disconnected) => disconnected,
        error: (error) => currentDeviceState);

    if (deviceState == const DeviceState.disconnected()) {
      return ConnectWidget(widget.scannedDevice);
    } else if (deviceState == const DeviceState.connected()) {
      return DisconnectWidget(widget.scannedDevice);
    } else {
      return const Text('');
    }
  }
}

/// Button to create a connection to [scannedDevice].
class ConnectWidget extends ConsumerWidget {
  final ScannedDevice scannedDevice;

  const ConnectWidget(this.scannedDevice, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const TextButton(
      onPressed: null,
      child: (Text('Connect')),
    );
  }
}

/// Button to close the connection to [scannedDevice].
class DisconnectWidget extends ConsumerWidget {
  final ScannedDevice scannedDevice;

  const DisconnectWidget(this.scannedDevice, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const TextButton(
      onPressed: null,
      child: (Text('Disconnect')),
    );
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
