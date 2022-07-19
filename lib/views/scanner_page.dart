import 'package:bandy_client/ble/scanner/logic/scanner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';

import '../ble/scanner/logic/scanned_device.dart';

class ScannerResultsRoute extends StatelessWidget {
  const ScannerResultsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        actions: const [
          ScannerControlWidget(),
        ],
      ),
      body: const ScannerResultsWidget(),
    );
  }
}

class ScannerControlWidget extends ConsumerWidget with UiLoggy {
  const ScannerControlWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannerState = ref.watch(scannerStateNotifierProvider);
    final scanner = ref.read(scannerStateNotifierProvider.notifier);

    return scannerState.scanning
        ? IconButton(
            icon: const Icon(Icons.cancel),
            tooltip: 'Stop',
            onPressed: () => scanner.stopScanning(),
          )
        : IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => scanner.startScanning(),
          );
  }
}

class ScannerResultsWidget extends ConsumerWidget with UiLoggy {
  const ScannerResultsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannerState = ref.watch(scannerStateNotifierProvider);

    return scannerState.when(
        (scanning, devices) => _scanResultsList(devices, scanning),
        initial: (scanning) => NoResultsWidget(scanning: scanning),
        loading: (scanning) => NoResultsWidget(scanning: scanning),
        error: (scanning, message) => Center(child: Text(message)));
  }

  Widget _scanResultsList(List<ScannedDevice> devices, bool scanning) {
    return (devices.isEmpty && scanning)
        ? const Center(child: CircularProgressIndicator.adaptive())
        : ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final d = devices[index];
              return ListTile(
                key: Key(d.deviceId),
                leading: Text("${d.rssi}"),
                title: Text(d.name),
                subtitle: Text(d.deviceId),
                onTap: () => _selectDevice(context, d),
              );
            });
  }

  _selectDevice(BuildContext context, ScannedDevice device) async {
    final navigator = Navigator.of(context);
    final useIt = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(device.name),
          content: const Text("Use this device?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (useIt ?? false) {
      navigator.pop(device);
    }
  }
}

class NoResultsWidget extends StatelessWidget {
  final bool scanning;

  const NoResultsWidget({
    super.key,
    required this.scanning,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: (scanning
            ? const Text("Waiting for scan results")
            : const Text("Tap refresh to start scanning")));
  }
}
