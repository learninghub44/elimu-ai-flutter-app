import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Subject/topic progress tracking goes here.\n\n'
            'Suggested v1.1: pull quiz attempt history from GET /api/ai/history '
            'and a new GET /api/progress/summary endpoint, then chart scores per subject.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
