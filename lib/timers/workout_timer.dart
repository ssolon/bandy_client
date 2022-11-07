import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_timer.g.dart';

@riverpod
class WorkoutTimerNotifier extends _$WorkoutTimerNotifier {
  Timer? timer;

  @override
  Duration build() {
    ref.onDispose(() {
      timer?.cancel();
    });

    return reset();
  }

  /// Reset, or initialize, our timer.
  Duration reset() {
    timer?.cancel();
    state = Duration.zero;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state += const Duration(seconds: 1);
    });

    return state;
  }
}
