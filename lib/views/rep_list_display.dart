import 'package:bandy_client/ble/scanner/logic/scanned_device.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final eFmt = NumberFormat.decimalPattern();

class RepListWidget extends ConsumerWidget {
  final ScannedDevice device;
  const RepListWidget(this.device, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reps = ref.watch(workoutSetNotifierProvider(device)).maybeWhen(
        (uuid, name, effort, reps) => reps,
        orElse: () => List<RepCount>.empty());

    return RepListTableWidget(reps);
  }
}

class RepListTableWidget extends ConsumerStatefulWidget {
  final List<RepCount> reps;
  const RepListTableWidget(this.reps, {super.key});

  @override
  RepListWidgetState createState() => RepListWidgetState();
}

class RepListWidgetState extends ConsumerState<RepListTableWidget> {
  @override
  void initState() {
    super.initState();
  }

  Iterable<RepCount> _displayReps = const Iterable.empty();
  bool _sortAscending = false;

  @override
  Widget build(BuildContext context) {
    _displayReps = _sortAscending ? widget.reps : widget.reps.reversed;

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
          const DataColumn(
            label: Text(
              'Effort\nT/C/E',
              textAlign: TextAlign.center,
            ),
            numeric: false,
          )
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
        DataCell(Text("${eFmt.format(rep.effort.total.roundToDouble())}"
            "/${eFmt.format(rep.effort.concentric.roundToDouble())}"
            "/${eFmt.format(rep.effort.eccentric.roundToDouble())}")),
      ],
    );
  }
}
