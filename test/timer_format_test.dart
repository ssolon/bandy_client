import 'package:bandy_client/views/workout_display.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zero', () => expect(formatTimer(Duration.zero), '0'));

  test('< 10 seconds',
      () => expect(formatTimer(const Duration(seconds: 7)), '7'));

  test('> 10 seconds',
      () => expect(formatTimer(const Duration(seconds: 23)), '23'));

  test('< 10 minutes',
      () => expect(formatTimer(const Duration(minutes: 3)), '3:00'));

  test(
      '< 10 minutes < 10 seconds',
      () =>
          expect(formatTimer(const Duration(minutes: 3, seconds: 7)), '3:07'));

  test(
      '< 10 minutes > 10 seconds',
      () =>
          expect(formatTimer(const Duration(minutes: 3, seconds: 23)), '3:23'));

  test(
      '> 10 minutes < 10 seconds',
      () => expect(
          formatTimer(const Duration(minutes: 59, seconds: 3)), '59:03'));

  test(
      '> 10 minutes > 10 seconds',
      () => expect(
          formatTimer(const Duration(minutes: 44, seconds: 59)), '44:59'));

  test('< 10 hours',
      () => expect(formatTimer(const Duration(hours: 5)), '5:00:00'));

  test(
      '< 10 hours < 10 minutes',
      () =>
          expect(formatTimer(const Duration(hours: 9, minutes: 4)), '9:04:00'));

  test(
      '< 10 hours < 10 minutes < 10 seconds',
      () => expect(
          formatTimer(const Duration(hours: 7, minutes: 1, seconds: 2)),
          '7:01:02'));

  test('> 10 hours',
      () => expect(formatTimer(const Duration(hours: 13)), '13:00:00'));

  test(
      '> 10 hours > 10 minutes',
      () => expect(
          formatTimer(const Duration(hours: 19, minutes: 44)), '19:44:00'));

  test(
      '> 10 hours, > 10 minutes > 10 seconds',
      () => expect(
          formatTimer(const Duration(hours: 132, minutes: 59, seconds: 59)),
          '132:59:59'));
}
