import 'package:bandy_client/exercise/exercise.dart';
import 'package:uuid/uuid.dart';

/// For testing just define some dummy exercises

List<Exercise> dummyExerciseList = [
  Exercise(UuidValue('24b5507f-e428-4db2-bab9-070561ea78df'), 'Chest Press'),
  Exercise(
      UuidValue('78c4c452-1dfc-47a0-8b87-8fa6beead010'), 'Incline Chest Press'),
  Exercise(
      UuidValue('781413e4-0df7-4f72-82f6-9b5697a90b34'), 'Decline Chest Press'),
  Exercise(UuidValue('f8de849c-4df3-40f0-8114-42e17f26e5e7'), 'Bar curl'),
  Exercise(UuidValue('0aa0f3eb-9121-4599-adef-52bf6eb619c8'), 'Hammer Curl'),
  Exercise(
      UuidValue('71d9502a-8357-4609-ae63-7d8ca4f187c0'), 'Triceps pull)down'),
  Exercise(UuidValue('d789d77a-c83e-41d5-a7e5-5e0f41bb340f'), 'Good Morning)'),
];

final dummyExercises = {for (final e in dummyExerciseList) e.id: e};
