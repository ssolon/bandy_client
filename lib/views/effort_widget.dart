import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/effort/effort_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EffortWidget extends ConsumerStatefulWidget {
  final ScannedDevice device;
  const EffortWidget(this.device, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EffortWidgetState();
}

class _EffortWidgetState extends ConsumerState<EffortWidget> {
  double concentric = 0.0;
  double eccentric = 0.0;
  double total = 0.0;
  bool doReset = false;

  @override
  Widget build(BuildContext context) {
    final effort = ref.watch(effortNotifierProvider(widget.device));

    if (doReset) {
      concentric = 0.0;
      eccentric = 0.0;
      total = 0.0;
      doReset = false;
    } else {
      total += effort.abs();
      if (effort > 0) {
        concentric += effort;
      } else {
        eccentric += effort.abs();
      }
    }

    return GestureDetector(
      onLongPress: () async => _reset(context),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _tt('Eccentric', context)),
              Expanded(child: _tt('Total', context)),
              Expanded(child: _tt('Concentric', context)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _tv(eccentric.toString(), context)),
              Expanded(child: _tv(total.toString(), context)),
              Expanded(child: _tv(concentric.toString(), context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tv(String s, BuildContext context) {
    return Text(s,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center);
  }

  Widget _tt(String s, BuildContext context) {
    return Text(s,
        style: Theme.of(context).textTheme.labelSmall,
        textAlign: TextAlign.center);
  }

  Future<void> _reset(BuildContext context) async {
    final reset = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Reset effort counters?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text('Reset'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));

    if (reset ?? false) {
      setState(() {
        doReset = true;
      });
    }
  }
}
