import 'package:flutter/material.dart';

class StudentNotesView extends StatelessWidget {
  const StudentNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),

      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: Column(children: []),
      ),
    );
  }
}
