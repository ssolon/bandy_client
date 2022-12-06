import 'package:flutter/material.dart';

class SessionDetailsPage extends StatelessWidget {
  const SessionDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session 1234')),
      body: const Center(child: Text('Details')),
    );
  }
}
