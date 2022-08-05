import 'dart:async';

import 'package:bandy_client/ble/device/logic/device_provider.dart';
import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/views/rep_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'value_display.dart';

class DeviceDisplayWidget extends ConsumerStatefulWidget {
  final ScannedDevice scannedDevice;

  const DeviceDisplayWidget(this.scannedDevice, {super.key});

  @override
  ConsumerState<DeviceDisplayWidget> createState() =>
      _DeviceDisplayWidgetState();
}

class _DeviceDisplayWidgetState extends ConsumerState<DeviceDisplayWidget> {
  BuildContext? popupContext;

  // Automatically reconnect when disconnected. Initially set to true is set
  // to false when user explicitly disconnects and then back to true when
  // when we reconnect.
  bool autoReconnect = true;

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionProvider(widget.scannedDevice));

    // We only care about handling disconnected and erros
    connectionState.maybeMap<void>(null,
        initial: (_) {}, // Doesn't mattmer
        connecting: (_) => Timer.run(() => _connectingDialog(context)),
        connected: (_) => Timer.run(() => _handleConnected()),
        disconnected: (_) => Timer.run(() => _handleDisconnected(context, ref)),
        error: (error) => Timer.run(() => _handleError(context, error.message)),
        orElse: () {}); // Don't care

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("${widget.scannedDevice.name} (${widget.scannedDevice.deviceId})"),
        TextButton(
          onPressed: () => _doDisconnect(ref),
          child: const Text("Disconnect"),
        )
      ]),
      ValueDisplayWidget(widget.scannedDevice),
      RepDisplayWidget(widget.scannedDevice),
    ]);
  }

  /// Just get rid of any popup
  void _handleConnected() {
    _dismissPopup();
  }

  /// Auto-connect always (for now)
  void _handleDisconnected(BuildContext context, WidgetRef ref) {
    if (autoReconnect) {
      ref.read(connectionProvider(widget.scannedDevice).notifier).connect();
    } else {
      popupContext = context;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          actions: [
            ConnectButton(widget.scannedDevice, ref),
          ],
          title: Text("Disconnected from ${widget.scannedDevice.name}"),
        ),
      );
    }
  }

  void _connectingDialog(BuildContext context) async {
    _dismissPopup(); // Only one at a time (for now)
    autoReconnect = true;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          popupContext = context; // So we can be dismissed
          return AlertDialog(
              title: Text("Connecting to ${widget.scannedDevice.name}"),
              actions: [
                TextButton(
                  onPressed: () {
                    popupContext = null; // since we're popping ourself
                    Navigator.pop(context); // should trigger disconnected popup
                  },
                  child: const Text("Cancel"),
                )
              ],
              content: const AspectRatio(
                aspectRatio: 1.0,
                child: CircularProgressIndicator.adaptive(),
              ));
        });
  }

  void _handleError(BuildContext context, String? message) {
    // TODO We should ignore the GAT errors which seem to happen when
    // disconnected and probably several others but for now we'll just
    // display them until we can figure out which to ignore.
    _dismissPopup();
    showDialog(
      context: context,
      builder: (context) {
        popupContext = context;
        return AlertDialog(
            title: const Text('Error'),
            content: Text("Error: ${message ?? "Unknown error"}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ]);
      },
    );
  }

  // Dismiss popup, if there
  _dismissPopup() {
    if (popupContext != null) {
      Navigator.pop(popupContext!);
      popupContext = null;
    }
  }

  // Disconnect and turn off autoReconnect
  void _doDisconnect(WidgetRef ref) {
    autoReconnect = false;
    ref
        .read(deviceNotifierProvider(widget.scannedDevice).notifier)
        .disconnect();
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
