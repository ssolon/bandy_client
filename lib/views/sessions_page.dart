import 'package:bandy_client/main.dart';
import 'package:bandy_client/workout_session/list/workout_session_list_notifier.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionsPage extends ConsumerStatefulWidget {
  const SessionsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SessionsPageState();
}

class _SessionsPageState extends ConsumerState<SessionsPage> {
  int retry = 0;

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(workoutSessionListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
        actions: [
          // TODO Some sort of feedback on refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => _refresh(),
          ),
        ],
      ),
      body: sessions.when(
        error: _handleError,
        loading: () => const CircularProgressIndicator(),
        data: (data) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: data.items.length,
            itemBuilder: (context, index) {
              final session = data.items[index];
              return GestureDetector(
                onTap: () {
                  Beamer.of(context)
                      .beamToNamed("/sessions/${session.sessionId}");
                },
                child: Card(
                  key: ValueKey(session.sessionId),
                  child: ListTile(title: Text(session.sessionAt.toString())),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget? _handleError(Object error, StackTrace stackTrace) {
    talker.handle(error, stackTrace);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("Error fetching sessions=$error"),
          ElevatedButton(
            onPressed: () {
              retry += 1;
              _refresh();
            },
            child: Text('Retry ($retry tries)'),
          ),
        ],
      ),
    );
  }

  _refresh() {
    ref.read(workoutSessionListNotifierProvider.notifier).fetch();
  }
}
