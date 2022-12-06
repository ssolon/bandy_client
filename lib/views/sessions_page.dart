import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Details'),
          onPressed: () => GoRouter.of(context).go('/sessions/details/1234'),
        ),
      ),
    );
  }
}
