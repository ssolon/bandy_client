import 'package:bandy_client/views/effort_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ble/device/logic/device_provider.dart';
import '../ble/scanner/logic/scanned_device.dart';

class ValueDisplayWidget extends ConsumerWidget {
  final ScannedDevice device;

  const ValueDisplayWidget(this.device, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instant = ref.watch(valueProvider(device));

    return Center(
      child: Column(
        children: [
          EffortWidget(device),
          Text(
            "${instant.reading}",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
