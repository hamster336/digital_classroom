import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/submission/bloc/submission_bloc.dart';

class SubmissionsView extends StatelessWidget {
  final String classId;
  final String subjectId;
  final String assignmentId;

  const SubmissionsView({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.assignmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Submissions')),
      body: RefreshIndicator(
        onRefresh: () async {
          final bloc = context.read<SubmissionBloc>();
          bloc.add(RefreshStudents(classId: classId, subjectId: subjectId));
          await bloc.stream.firstWhere(
            (state) => state is StudentsLoaded || state is StudentsLoadingError,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: BlocListener<SubmissionBloc, SubmissionState>(
            listener: (context, state) {
              if (state is StudentsLoadingError) {
                CustomWidgets.customAltertBox(context, state.message, () {});
              }
            },
            child: Expanded(
              child: BlocBuilder<TeacherAssignmentBloc, TeacherAssignmentState>(
                builder: (context, state) {
                  final List<AppFile> submissions =
                      (state is TeacherAssignmentLoaded)
                      ? state.submissions
                      : [];

                  return BlocBuilder<SubmissionBloc, SubmissionState>(
                    builder: (context, state) {
                      if (state is LoadingStudents) {
                        return CustomWidgets.customLoader();
                      }

                      if (state is StudentsLoaded) {
                        final students = state.students;

                        if (students.isEmpty) {
                          return CustomWidgets.customScrollableText(
                            context,
                            'No students :(',
                          );
                        }

                        return ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];

                            final sub = submissions.firstWhereOrNull(
                              (s) =>
                                  (s.uploaderId == student.id) &&
                                  (s.ownerId == assignmentId),
                            );

                            return CustomWidgets.studentSubmissionCard(
                              student: student,
                              submission: sub,
                              icon: Icons.download,
                              onDownload: () {},
                            );
                          },
                        );
                      }

                      return CustomWidgets.customScrollableText(
                        context,
                        'Error occured :(\nSwipe down to  refresh.',
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
