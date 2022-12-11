import 'package:bandy_client/exercise/exercise.dart';
import 'package:bandy_client/routine/rep_counter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_set_state.freezed.dart';

@freezed
class WorkoutSetState with _$WorkoutSetState {
  const WorkoutSetState._();

  /// Data is present state
  const factory WorkoutSetState(
      {Exercise? exercise,
      required int setNumber,
      required List<RepCount> reps}) = Data;

  /// Initial/default state
  const factory WorkoutSetState.initial() = Initial;

  /// Data is loading state
  const factory WorkoutSetState.loading() = Loading;

  /// Error when loading data state
  const factory WorkoutSetState.error([String? message]) = Error;

  /// Return the start of this set which is the first instance of the first rep.
  DateTime? get starting {
    // ignore: unnecessary_this
    return this.maybeWhen(
        (exercise, setNumber, reps) =>
            reps.isNotEmpty ? reps.first.reps.instants.first.when : null,
        orElse: () => null);
  }
}
