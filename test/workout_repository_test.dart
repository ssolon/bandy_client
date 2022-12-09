import 'dart:convert';

import 'package:bandy_client/repositories/db/init_bandy_db.dart';
import 'package:bandy_client/repositories/db/kaleidalog_sqlite.dart';
import 'package:bandy_client/repositories/workout_repository.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_state.dart';
import 'package:bandy_client/workout_session/current/workout_session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class MockDB extends Mock implements DB {}

main() {
  late ProviderContainer container;
  MockDB mockDB = MockDB();

  group('Workout session test', () {
    final dummyUuidValue = UuidValue(Uuid.NAMESPACE_NIL);

    setUp(() {
      registerFallbackValue(UuidValue(Uuid.NAMESPACE_NIL));
      container = ProviderContainer(overrides: [
        kaleidaLogDbProvider.overrideWithValue(mockDB),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('Create session event', () async {
      final starting = DateTime(2022, 12, 1, 0, 0);
      final ending = starting.add(const Duration(minutes: 10));
      final List<WorkoutSetState> sets = [];
      final s = WorkoutSessionState.completed(
          id: dummyUuidValue, starting: starting, ending: ending, sets: sets);

      when(
        () => mockDB.createEvent(
          eventId: any(named: 'eventId'),
          at: any(named: 'at'),
          eventTypeId: any(named: 'eventTypeId'),
          parentId: any(named: 'parentId'),
          jsonDetails: any(named: 'jsonDetails'),
        ),
      ).thenAnswer((_) => Future.value(dummyUuidValue));

      final id = container.read(workoutRepositoryProvider).saveSession(s);
      expect(id, completes, reason: "saveSession completes");

      verify(() => mockDB.createEvent(
              eventId: dummyUuidValue,
              at: starting,
              eventTypeId: UuidValue(sessionTypeUUID),
              parentId: null,
              jsonDetails: json.encode({'ending': ending.toIso8601String()})))
          .called(1);
    });
  });
}
