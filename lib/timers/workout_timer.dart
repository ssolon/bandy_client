import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_timer.g.dart';

@riverpod
class WorkoutTimerNotifier extends _$WorkoutTimerNotifier {
  Duration current = Duration.zero;
  Timer? timer;

  @override
  Duration build() {
    ref.onDispose(() {
      timer?.cancel();
    });

    reset();

    return current;
  }

  /// Reset, or initialize, our timer.
  void reset() {
    timer?.cancel();
    current = Duration.zero;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      current += const Duration(seconds: 1);
      state = current;
    });

    state = current;
  }
}
