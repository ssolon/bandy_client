import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionsPage extends ConsumerStatefulWidget {
  const SessionsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SessionsPageState();
}

class _SessionsPageState extends ConsumerState<SessionsPage> {
  static final items = [
    ['20221202 14:22', 'Session1'],
    ['20221207 16:50', 'Session2'],
    ['20221214 13:18', 'Session3'],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                final idIndex = index;
                Beamer.of(context)
                    .beamToNamed("/sessions/${items[idIndex][1]}");
              },
              child: Card(
                child: ListTile(title: Text(items[index][0])),
              ),
            );
          },
        ),
      ),
    );
  }
}
