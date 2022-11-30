import 'package:bandy_client/exercise/list/exercise_list_state.dart';
import 'package:bandy_client/repositories/db/kaleidalog_sqlite.dart';
import 'package:bandy_client/workout_session/workout_session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final workoutRepositoryProvider = Provider((ref) => WorkoutRepository(ref));

const kaleidaTagBandy = 'bandy';
const kaleidaTagExercise = 'exercise';

class WorkoutRepository {
  final Ref ref;

  WorkoutRepository(this.ref);

  String? saveSession(WorkoutSessionState theSession) {
    return null;
  }

  Future<QueryResult> getExercises() async {
    final tags = [kaleidaTagBandy, kaleidaTagExercise];
    final exercises =
        ref.read(kaleidaLogDbProvider).fetchEventTypesByTags(tags);

    // TODO DTO objects?
    return exercises;
  }
}
