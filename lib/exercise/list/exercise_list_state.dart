import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_list_state.freezed.dart';

@freezed
class ExerciseListItem with _$ExerciseListItem {
  const factory ExerciseListItem({required String id, required String name}) =
      _ExerciseListItem;
}

@freezed
class ExerciseListState with _$ExerciseListState {
  const factory ExerciseListState({required List<ExerciseListItem> items}) =
      Data;

  const factory ExerciseListState.initial() = Initial;

  const factory ExerciseListState.loading() = Loading;

  const factory ExerciseListState.error([String? message]) = Error;
}
