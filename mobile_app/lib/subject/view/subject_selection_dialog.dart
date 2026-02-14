import 'package:flutter/material.dart';
import 'package:mobile_app/subject/model/subject.dart';

class SubjectSelectionDialog extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectSelectionDialog({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Subject'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];

            return ListTile(
              title: Text(subject.name),
              onTap: () {
                Navigator.pop(context, subject);
              },
            );
          },
        ),
      ),
    );
  }
}