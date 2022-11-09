import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'current_exercise_state.freezed.dart';

@freezed
class CurrentExerciseState with _$CurrentExerciseState {
  // TODO Add exercise type
  factory CurrentExerciseState({required UuidValue id, required String name}) =
      Data;

  factory CurrentExerciseState.initial() = Initial;
  factory CurrentExerciseState.loading() = Loading;
  factory CurrentExerciseState.error([String? message]) = Error;
}
