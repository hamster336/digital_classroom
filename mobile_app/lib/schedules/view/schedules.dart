import 'package:flutter/material.dart';

class Schedules extends StatelessWidget {
  final String classId;
  const Schedules({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Schedules')),
    );
  }
}
