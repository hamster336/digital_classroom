import 'package:flutter/material.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/user/models/student.dart';

class SubmissionsView extends StatelessWidget {
  final List<Student> students;
  final List<AppFile> submissions;

  const SubmissionsView({
    super.key,
    required this.students,
    required this.submissions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Submissions')),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10)),
      ),
    );
  }
}
