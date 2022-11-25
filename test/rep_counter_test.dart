import 'package:bandy_client/ble/device/logic/device_state.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_sets.dart';

late InstantHandler handler;

void main() {
  setUp(() {
    handler = InstantHandler();
  });
  group('Inflection point', () {
    test('No readings', () {
      expect(handler.inflectionPoint(), Inflection.continues,
          reason: 'No inflection with no points');
    });

    test('One reading of zero', () {
      handler.add(Instant(reading: 0, when: DateTime.now()));
      expect(handler.inflectionPoint(), Inflection.continues,
          reason: 'Too few readings');
    });

    test('Two readings of zero', () {
      handler.add(Instant(reading: 0, when: DateTime.now()));
      handler.add(Instant(reading: 0, when: DateTime.now()));
      expect(handler.inflectionPoint(), Inflection.continues,
          reason: 'Duplicate readings ignored');
    });

    test('Two non-zero readings', () {
      handler.add(Instant(reading: 1, when: DateTime.now()));
      handler.add(Instant(reading: 5, when: DateTime.now()));
      expect(handler.inflectionPoint(), Inflection.continues,
          reason: 'No enough points');
    });
    test('Three in a row', () {
      handler.add(Instant(reading: 1, when: DateTime.now()));
      handler.add(Instant(reading: 5, when: DateTime.now()));
      handler.add(Instant(reading: 7, when: DateTime.now()));
      expect(handler.inflectionPoint(), Inflection.continues,
          reason: 'No inflection');
    });
    test('Turn down', () {
      handler.add(Instant(reading: 1, when: DateTime.now()));
      handler.add(Instant(reading: 5, when: DateTime.now()));
      handler.add(Instant(reading: 3, when: DateTime.now()));
      expect(handler.inflectionPoint(), Inflection.turnDown,
          reason: 'Turn down');
    });
    test('Turn up', () {
      handler.add(Instant(reading: 5, when: DateTime.now()));
      handler.add(Instant(reading: 3, when: DateTime.now()));
      handler.add(Instant(reading: 7, when: DateTime.now()));
      expect(handler.inflectionPoint(), Inflection.turnUp, reason: 'Turn up');
    });
  });

  group(
    'TestSets',
    () {
      test(
        'One rep',
        () {
          runSet(test1, 'One rep');
        },
      );
      test(
        'Two reps start zero',
        () {
          runSet(test2, 'Two reps starting zero');
        },
      );
      test(
        'Four reps end zero',
        () {
          runSet(test3, 'Four reps ending zero');
        },
      );
      test(
        'Six (seven?) reps end zero',
        () {
          runSet(test8, 'Eight reps ending zero');
        },
      );
    },
  );
}
