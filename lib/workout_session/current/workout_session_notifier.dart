import 'package:bandy_client/main.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_state.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'workout_session_state.dart';

part 'workout_session_notifier.g.dart';

@Riverpod(keepAlive: true)
class WorkoutSessionNotifier extends _$WorkoutSessionNotifier with UiLoggy {
  Uuid? currentSessionId;
  List<WorkoutSetState> sets = [];

  @override
  WorkoutSessionState build() {
    return WorkoutSessionState.initial();
  }

  /// Initial
  void initial() {
    state = WorkoutSessionState.initial();
  }

  /// Create a new session starting now
  // TODO Make sure everything resets when we start a new session
  void start() {
    sets = [];
    state = WorkoutSessionState(starting: DateTime.now(), sets: sets);
  }

  /// Add a set to this session
  void addSet(WorkoutSetState workoutSet) {
    workoutSet.maybeMap((set) {
      state.maybeMap((inProgress) {
        sets.add(set);
        state = inProgress.copyWith(sets: sets);
      }, finishing: (value) {
        // FIXME Update state with new set?
        sets.add(set);
      }, orElse: () {});
    }, orElse: () {
      // Ignore anything other than Data
      talker.warning(
          "workoutSession:addSet called with set=${workoutSet.runtimeType}");
    });
  }

  /// End the current session
  void finish() {
    state = state.maybeWhen(
      (starting, sets) {
        //!!!! Will this work to deliver the message
        state = WorkoutSessionState.finishing();
        return WorkoutSessionState.completed(
            starting: starting, ending: DateTime.now(), sets: sets);
      },
      orElse: () => WorkoutSessionState.error(
          "Session cannot be finished (state = ${state.runtimeType})"),
    );
  }
}
