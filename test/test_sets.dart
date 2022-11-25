import 'dart:math';

import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'rep_counter_test.dart';

class TestInstant extends Instant {
  final int? startRep;

  TestInstant({this.startRep, required super.when, required super.reading});
}

class TestSet {
  final int count;
  final List<TestInstant> reps;
  final int? startRep;
  TestSet({required this.count, required this.reps, this.startRep});
}

/// Run a test against [testSet]
void runSet(TestSet testSet, String decription) {
  int countReps = 0;
  List<TestInstant> currentRepInstants = [];

  bool expectedRep(r) => r.startRep != null && r.startRep! > 1;

  // final instants = testSet.reps as List<TestInstant>;
  for (final r in testSet.reps) {
    currentRepInstants.add(r);
    final result = handler.add(r);
    if (result != null) {
      expect(expectedRep(r), isTrue,
          reason: 'Handler returned expected rep at ${r.when.year}');
    }
    if (expectedRep(r)) {
      countReps++;
      expect(result, isNotNull,
          reason: "Start rep ${r.startRep} at ${r.when.year}");

      // We go beyond end of rep (to detect inflection) so truncate for test

      final checkRepInstants =
          currentRepInstants.take(currentRepInstants.length - 1).toList();
      checkReportedInstants(checkRepInstants, result!.reps.instants);

      // We retain the last two instants: the inflection point (min) and
      // the following that made the inflection point so retain those two.
      currentRepInstants =
          currentRepInstants.skip(currentRepInstants.length - 2).toList();
    }
  }

  // Force the last rep
  final lastResult = handler.reportRep();
  expect(lastResult, isNotNull, reason: "Final rep after $countReps");
  expect(lastResult!.count, countReps + 1, reason: "Right number of reps");
  checkReportedInstants(currentRepInstants, lastResult.reps.instants);
}

void checkReportedInstants(
    List<TestInstant> testReps, List<Instant> reportedReps) {
  expect(reportedReps.length, testReps.length, reason: "Instants length");
  for (int i = 0; i < min(testReps.length, reportedReps.length); i++) {
    expect(reportedReps[i].reading, testReps[i].reading, reason: "reading[$i]");
    expect(reportedReps[i].when, testReps[i].when, reason: "when[$i]");
  }
}

final test2 = TestSet(count: 2, reps: [
  TestInstant(when: DateTime(1), reading: 0, startRep: 1),
  TestInstant(when: DateTime(2), reading: 5),
  TestInstant(when: DateTime(3), reading: 10),
  TestInstant(when: DateTime(4), reading: 20),
  TestInstant(when: DateTime(5), reading: 15),
  TestInstant(when: DateTime(6), reading: 9),
  TestInstant(when: DateTime(7), reading: 5),
  TestInstant(when: DateTime(8), reading: 10, startRep: 2),
  TestInstant(when: DateTime(9), reading: 12),
  TestInstant(when: DateTime(10), reading: 22),
  TestInstant(when: DateTime(11), reading: 17),
  TestInstant(when: DateTime(12), reading: 13),
  TestInstant(when: DateTime(13), reading: 9),
]);

final test1 = TestSet(count: 1, reps: [
  TestInstant(when: DateTime(10), reading: 5),
  TestInstant(when: DateTime(20), reading: 9),
  TestInstant(when: DateTime(22), reading: 10),
  TestInstant(when: DateTime(23), reading: 11),
  TestInstant(when: DateTime(23), reading: 12),
  TestInstant(when: DateTime(30), reading: 25),
  TestInstant(when: DateTime(40), reading: 24),
  TestInstant(when: DateTime(45), reading: 20),
  TestInstant(when: DateTime(50), reading: 8),
]);

final test8 = TestSet(count: 8, reps: [
  TestInstant(when: DateTime(7), reading: 8, startRep: 1),
  TestInstant(when: DateTime(10), reading: 12),
  TestInstant(when: DateTime(15), reading: 15),
  TestInstant(when: DateTime(17), reading: 20),
  TestInstant(when: DateTime(20), reading: 15),
  TestInstant(when: DateTime(22), reading: 12),
  TestInstant(when: DateTime(23), reading: 11),
  TestInstant(when: DateTime(24), reading: 9),
  TestInstant(when: DateTime(25), reading: 11, startRep: 2),
  TestInstant(when: DateTime(26), reading: 15),
  TestInstant(when: DateTime(27), reading: 16),
  TestInstant(when: DateTime(28), reading: 17),
  TestInstant(when: DateTime(29), reading: 18),
  TestInstant(when: DateTime(30), reading: 22),
  TestInstant(when: DateTime(31), reading: 30),
  TestInstant(when: DateTime(32), reading: 21),
  TestInstant(when: DateTime(33), reading: 22, startRep: 3),
  TestInstant(when: DateTime(34), reading: 23),
  TestInstant(when: DateTime(34), reading: 24),
  TestInstant(when: DateTime(35), reading: 25),
  TestInstant(when: DateTime(36), reading: 23),
  TestInstant(when: DateTime(37), reading: 22),
  TestInstant(when: DateTime(38), reading: 21),
  TestInstant(when: DateTime(39), reading: 20),
  TestInstant(when: DateTime(40), reading: 19),
  TestInstant(when: DateTime(41), reading: 18),
  TestInstant(when: DateTime(42), reading: 17),
  TestInstant(when: DateTime(43), reading: 16),
  TestInstant(when: DateTime(44), reading: 11),
  TestInstant(when: DateTime(45), reading: 14, startRep: 4),
  TestInstant(when: DateTime(50), reading: 17),
  TestInstant(when: DateTime(51), reading: 22),
  TestInstant(when: DateTime(60), reading: 19),
  TestInstant(when: DateTime(62), reading: 13),
  TestInstant(when: DateTime(65), reading: 7),
  TestInstant(when: DateTime(70), reading: 11, startRep: 5),
  TestInstant(when: DateTime(72), reading: 14),
  TestInstant(when: DateTime(73), reading: 15),
  TestInstant(when: DateTime(74), reading: 12),
  TestInstant(when: DateTime(80), reading: 11),
  TestInstant(when: DateTime(85), reading: 6),
  TestInstant(when: DateTime(90), reading: 9, startRep: 6),
  TestInstant(when: DateTime(92), reading: 12),
  TestInstant(when: DateTime(94), reading: 14),
  TestInstant(when: DateTime(96), reading: 12),
  TestInstant(when: DateTime(98), reading: 13, startRep: 7),
  TestInstant(when: DateTime(100), reading: 9),
  TestInstant(when: DateTime(110), reading: 11, startRep: 8),
  TestInstant(when: DateTime(120), reading: 13),
  TestInstant(when: DateTime(121), reading: 14),
  TestInstant(when: DateTime(130), reading: 9),
  TestInstant(when: DateTime(132), reading: 7),
  TestInstant(when: DateTime(140), reading: 0),
]);

final test2_2 = TestSet(count: 2, reps: [
  TestInstant(when: DateTime(3), reading: 3),
  TestInstant(when: DateTime(5), reading: 7),
  TestInstant(when: DateTime(9), reading: 12),
  TestInstant(when: DateTime(12), reading: 9),
  TestInstant(when: DateTime(15), reading: 8),
  TestInstant(when: DateTime(17), reading: 12),
  TestInstant(when: DateTime(20), reading: 15),
  TestInstant(when: DateTime(22), reading: 12),
  TestInstant(when: DateTime(23), reading: 9),
  TestInstant(when: DateTime(25), reading: 6),
]);

final test3 = TestSet(count: 3, reps: [
  TestInstant(when: DateTime(0), reading: 0),
  TestInstant(when: DateTime(4), reading: 6),
  TestInstant(when: DateTime(7), reading: 9),
  TestInstant(when: DateTime(9), reading: 12),
  TestInstant(when: DateTime(12), reading: 20),
  TestInstant(when: DateTime(13), reading: 21),
  TestInstant(when: DateTime(14), reading: 22),
  TestInstant(when: DateTime(15), reading: 19),
  TestInstant(when: DateTime(16), reading: 18),
  TestInstant(when: DateTime(17), reading: 17),
  TestInstant(when: DateTime(18), reading: 16),
  TestInstant(when: DateTime(19), reading: 15),
  TestInstant(when: DateTime(22), reading: 2),
  TestInstant(when: DateTime(25), reading: 6, startRep: 2),
  TestInstant(when: DateTime(30), reading: 12),
  TestInstant(when: DateTime(35), reading: 16),
  TestInstant(when: DateTime(40), reading: 14),
  TestInstant(when: DateTime(42), reading: 9),
  TestInstant(when: DateTime(45), reading: 0),
  TestInstant(when: DateTime(50), reading: 4, startRep: 3),
  TestInstant(when: DateTime(55), reading: 7),
  TestInstant(when: DateTime(60), reading: 9),
  TestInstant(when: DateTime(61), reading: 4),
  TestInstant(when: DateTime(65), reading: 8, startRep: 4),
  TestInstant(when: DateTime(66), reading: 10),
  TestInstant(when: DateTime(67), reading: 4),
  TestInstant(when: DateTime(68), reading: 0),
]);
