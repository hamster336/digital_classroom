import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';

class TeacherAssignmentDetailScreen extends StatelessWidget {
  final Assignment assignment;
  final Classroom cls;
  const TeacherAssignmentDetailScreen({
    super.key,
    required this.assignment,
    required this.cls,
  });

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
                    cls: cls,
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
              BlocBuilder<TeacherAssignmentBloc, TeacherAssignmentState>(
                builder: (context, state) {
                  final List<AppFile> submissions =
                      (state is TeacherAssignmentLoaded)
                      ? state.submissions
                      : [];

                  final subCount = submissions
                      .where((s) => s.ownerId == assignment.id)
                      .map((s) => s.uploaderId)
                      .toSet();

                  return CustomWidgets.submissionDetailsForTeacher(
                    assignment,
                    count: subCount.length,
                    total: cls.studentCount,
                  );
                },
              ),

              const SizedBox(height: 5),
              
              // view submissions
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
                      'View Submissions',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
