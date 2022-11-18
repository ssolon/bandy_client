import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RepListWidget extends ConsumerStatefulWidget {
  final ScannedDevice device;

  const RepListWidget(this.device, {super.key});

  @override
  RepListWidgetState createState() => RepListWidgetState();
}

class RepListWidgetState extends ConsumerState<RepListWidget> {
  @override
  void initState() {
    super.initState();
  }

  Iterable<RepCount> _displayReps = const Iterable.empty();
  bool _sortAscending = false;

  @override
  Widget build(BuildContext context) {
    final reps = ref.watch(workoutSetNotifierProvider(widget.device)).maybeWhen(
        (uuid, name, reps) => reps,
        orElse: () => List<RepCount>.empty());

    _displayReps = _sortAscending ? reps : reps.reversed;

    return DataTable(
        columns: [
          DataColumn(
            label: const Text("Rep"),
            numeric: true,
            onSort: (columnIndex, ascending) {
              if (columnIndex == 0) {
                setState(() {
                  _sortAscending = !_sortAscending;
                });
              }
            },
          ),
          const DataColumn(
              label: Text(
                'Max\nResistance',
                textAlign: TextAlign.center,
              ),
              numeric: true),
        ],
        sortAscending: _sortAscending,
        sortColumnIndex: 0,
        rows: [for (final l in _displayReps) _makeRepRow(l)]);
  }

  _makeRepRow(RepCount rep) {
    return DataRow(
      key: ValueKey(rep.count),
      cells: [
        DataCell(Text(rep.count.toString())),
        DataCell(Text(rep.maxValue.toString())),
      ],
    );
  }
}
