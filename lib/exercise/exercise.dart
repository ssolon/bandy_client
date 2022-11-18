import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'exercise.freezed.dart';

@freezed
class Exercise with _$Exercise {
  factory Exercise(UuidValue id, String name) = _Exercise;
}
