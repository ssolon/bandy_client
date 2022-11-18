import 'package:bandy_client/exercise/exercise.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_exercise_state.freezed.dart';

@freezed
class CurrentExerciseState with _$CurrentExerciseState {
  // TODO Add exercise type
  factory CurrentExerciseState({required Exercise exercise}) = Data;

  factory CurrentExerciseState.initial() = Initial;
  factory CurrentExerciseState.loading() = Loading;
  factory CurrentExerciseState.error([String? message]) = Error;
}
