import 'dart:async';

import 'package:bandy_client/workout_session/current/workout_session_notifier.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../workout_session/current/workout_session_state.dart';

part 'workout_timer.g.dart';

@Riverpod(keepAlive: true)
class WorkoutTimerNotifier extends _$WorkoutTimerNotifier with UiLoggy {
  Timer? timer;

  @override
  Duration build() {
    ref.onDispose(() {
      timer?.cancel();
    });

    // Start when we go to inProgress and stop when going from inProgress.
    ref.listen(workoutSessionNotifierProvider,
        (WorkoutSessionState? previous, WorkoutSessionState next) {
      final prevInProgess = previous?.mapOrNull((value) => true) != null;

      next.mapOrNull(
        (value) {
          // next inProgress
          if (!prevInProgess) {
            reset(); // start
          }
        },
        completed: (value) {
          timer?.cancel(); // stop timer on completed
          timer = null;
        },
      );
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
