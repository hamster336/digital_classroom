import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';

class TeacherAssignmentDetailScreen extends StatelessWidget {
  final Assignment assignment;
  const TeacherAssignmentDetailScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              // assignment details
              const Text(
                'ASSIGNMENT DETAILS:',
                style: TextStyle(color: Colors.black45),
              ),
              const SizedBox(height: 5),

              BlocBuilder<SubjectBloc, SubjectState>(
                builder: (context, state) {
                  final subjects = (state is SubjectLoaded)
                      ? state.subjects
                      : [];

                  final sub =
                      subjects.firstWhere((s) => s.id == assignment.subjectId)
                          as Subject;
                  return CustomWidgets.teachersAssignmentCards(
                    context: context,
                    assignment: assignment,
                    subjectName: sub.name,
                    detailed: true,
                  );
                },
              ),

              const SizedBox(height: 15),

              // submission details
              const Text(
                'SUBMISSION DETAILS:',
                style: TextStyle(color: Colors.black45),
              ),
              const SizedBox(height: 5),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
