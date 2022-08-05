import 'package:bandy_client/routine/rep_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ble/scanner/logic/scanned_device.dart';

class RepDisplayWidget extends ConsumerWidget {
  final ScannedDevice device;
  const RepDisplayWidget(this.device, {super.key});

  @override
  Widget build(context, ref) {
    final count = ref.watch(repCounterStateProvider(device));

    return GestureDetector(
        onTap: () => ref.read(repCounterStateProvider(device).notifier).reset(),
        child: Row(children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Reps',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(count.count.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Max',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(count.maxValue.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
          ),
        ]));
  }
}
