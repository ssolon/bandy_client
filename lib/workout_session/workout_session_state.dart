import 'package:bandy_client/routine/workout_set/logic/workout_set_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'workout_session_state.freezed.dart';

@freezed
class WorkoutSessionState with _$WorkoutSessionState {
  factory WorkoutSessionState(
      {required DateTime starting,
      required List<WorkoutSetState> sets}) = InProgress;

  factory WorkoutSessionState.completed(
      {UuidValue? id,
      required DateTime starting,
      required DateTime ending,
      required List<WorkoutSetState> sets}) = Completed;

  factory WorkoutSessionState.initial() = Initial;
  factory WorkoutSessionState.loading() = Loading;
  factory WorkoutSessionState.error([String? message]) = Error;
}
