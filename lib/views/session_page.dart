import 'package:bandy_client/main.dart';
import 'package:bandy_client/routine/workout_set/logic/workout_set_state.dart';
import 'package:bandy_client/workout_session/details/workout_session_details_notifier.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final dateFormat = DateFormat.MMMEd().add_jms();

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  @override
  Widget build(BuildContext context) {
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final sessionId = UuidValue(beamState.pathParameters['sessionId']!);

    final session = ref.watch(workoutSessionDetailsNotifierProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Session"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: session.when(
            data: (data) => data.maybeWhen(
              (starting, sets) => Text(
                  "session_page:Unexpected state for sessionId=$sessionId type=${data.runtimeType}"),
              completed: (id, starting, ending, sets) => Column(
                children: [
                  Text(
                    dateFormat.format(starting),
                    key: ValueKey(sessionId),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (sets.isEmpty) const Text("No sets in this session"),
                  for (final s in sets) _WorkoutSetDisplayWidget(s),
                ],
              ),
              orElse: () => Text(
                  "session_page:Unexpected state for sessionId=$sessionId type=${data.runtimeType}"),
            ),
            error: (error, stackTrace) {
              talker.handle(error, stackTrace);
              return Text("Error fetching sessionId=$sessionId:$error)");
            },
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class _WorkoutSetDisplayWidget extends StatelessWidget {
  final WorkoutSetState workoutSet;

  const _WorkoutSetDisplayWidget(this.workoutSet, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        workoutSet.maybeWhen((exercise, setNumber, reps) {
          return Text("WorkoutSet - ${reps.length} reps");
        },
            orElse: () => Text(
                "WorkoutSetDisplay: Invalid set state=${workoutSet.runtimeType}"))
      ],
    );
  }
}
