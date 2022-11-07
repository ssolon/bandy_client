import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_exercise_state.freezed.dart';

@freezed
class CurrentExerciseState with _$CurrentExerciseState {
  factory CurrentExerciseState({required String id, required String name}) =
      Data;

  factory CurrentExerciseState.initial() = Initial;
  factory CurrentExerciseState.loading() = Loading;
  factory CurrentExerciseState.error([String? message]) = Error;
}
