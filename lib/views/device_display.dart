import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceDisplayWidget extends ConsumerWidget {
  final ScannedDevice scannedDevice;

  const DeviceDisplayWidget(this.scannedDevice, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(deviceNotifierProvider(scannedDevice));

    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("${scannedDevice.name} (${scannedDevice.deviceId})"),
          TextButton(
            child: const Text('Disconnect'),
            onPressed: () => _doDisconnect(ref),
          ),
        ]),
        device.map<Widget>((value) => _updateValue(context, value.reading),
            initial: (arg) => _handleInitial(context),
            connected: (arg) => _handleConnected(context),
            disconnected: (arg) => _handleDisconnected(context),
            error: (error) => _handleError(context, error.message)),
      ],
    );
  }

  Widget _handleInitial(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
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

  Widget _handleConnected(BuildContext context) {
    return const Center(child: Text("Connected"));
  }

  Widget _handleDisconnected(BuildContext context) {
    return const Center(
      child: Text("Disconnected"),
    );
  }

  Widget _handleError(BuildContext context, String? message) {
    return Center(child: Text("Error: ${message ?? '?'}"));
  }

  void _doDisconnect(WidgetRef ref) {
    ref.read(deviceNotifierProvider(scannedDevice).notifier).disconnect();
  }
}
