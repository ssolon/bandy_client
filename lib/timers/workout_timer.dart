import 'dart:async';

import 'package:bandy_client/workout_session/workout_session_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_timer.g.dart';

// TODO This probably shouldn't be autodispose (if it is) -- check generate stuff
@riverpod
class WorkoutTimerNotifier extends _$WorkoutTimerNotifier {
  Timer? timer;

  @override
  Duration build() {
    ref.onDispose(() {
      timer?.cancel();
    });

    // Reset when something changes on the session
    // TODO More logic here to handle different conditions?
    ref.listen(workoutSessionNotifierProvider, (previous, next) => reset());

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
