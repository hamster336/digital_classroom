import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';

class StudentAssignmentDetailsScreen extends StatelessWidget {
  final Assignment assignment;
  const StudentAssignmentDetailsScreen({super.key, required this.assignment});

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
                  return CustomWidgets.studentAssignmentCards(
                    detailed: true,
                    context: context,
                    assignment: assignment,
                    subjectName: sub.name,
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
              CustomWidgets.submissionDetails(assignment, null),

              const SizedBox(height: 15),

              // submit assignment
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2AB3AA),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      // (assignment.submitted)
                      //     ? 'Resubmit Assignment'
                      //     :
                      'Submit Assignment',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
