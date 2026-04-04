import 'package:flutter/material.dart';

class SchedulesView extends StatelessWidget {
  final String classId;
  const SchedulesView({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Schedules')),
    );
  }
}
