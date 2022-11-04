import 'package:bandy_client/routine/rep_counter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_set_state.freezed.dart';

@freezed
abstract class WorkoutSetState with _$WorkoutSetState {
  /// Data is present state
  const factory WorkoutSetState({required List<RepCount> reps}) = Data;

  /// Initial/default state
  const factory WorkoutSetState.initial() = Initial;

  /// Data is loading state
  const factory WorkoutSetState.loading() = Loading;

  /// Error when loading data state
  const factory WorkoutSetState.error([String? message]) = Error;
}
