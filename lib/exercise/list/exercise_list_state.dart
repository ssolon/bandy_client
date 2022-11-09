import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'exercise_list_state.freezed.dart';

@freezed
class ExerciseListItem with _$ExerciseListItem {
  const factory ExerciseListItem(
      {required UuidValue id, required String name}) = _ExerciseListItem;
}

@freezed
class ExerciseListState with _$ExerciseListState {
  const factory ExerciseListState({required List<ExerciseListItem> items}) =
      Data;

  const factory ExerciseListState.initial() = Initial;

  const factory ExerciseListState.loading() = Loading;

  const factory ExerciseListState.error([String? message]) = Error;
}
