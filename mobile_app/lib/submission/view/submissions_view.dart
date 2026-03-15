import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/submission/bloc/submission_bloc.dart';

class SubmissionsView extends StatelessWidget {
  final Classroom cls;
  final Subject subject;
  final String assignmentId;

  const SubmissionsView({
    super.key,
    required this.cls,
    required this.subject,
    required this.assignmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Submissions')),
      body: RefreshIndicator(
        onRefresh: () async {
          final subBloc = context.read<SubmissionBloc>();
          final asgnBloc = context.read<TeacherAssignmentBloc>();
          asgnBloc.add(
            RefreshAssignments(teacherId: subject.teacherId, classId: cls.id),
          );
          subBloc.add(RefreshStudents(classId: cls.id, subjectId: subject.id));

          await subBloc.stream.firstWhere(
            (state) => state is StudentsLoaded || state is StudentsLoadingError,
          );

          await asgnBloc.stream.firstWhere(
            (state) =>
                state is TeacherAssignmentLoaded ||
                state is TeacherAssignmentLoadingError,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: MultiBlocListener(
            listeners: [
              BlocListener<TeacherAssignmentBloc, TeacherAssignmentState>(
                listener: (context, state) {
                  if (state is DownloadAssignmentSubmissionError) {
                    CustomWidgets.customAltertBox(
                      context,
                      state.message,
                      () {},
                    );
                  }

                  if (state is DownloadAssignmentSubmissionSuccess) {
                    context.read<TeacherAssignmentBloc>().add(
                      RefreshAssignments(
                        teacherId: subject.teacherId,
                        classId: cls.id,
                      ),
                    );
                  }
                },
              ),
              BlocListener<SubmissionBloc, SubmissionState>(
                listener: (context, state) {
                  if (state is StudentsLoadingError) {
                    CustomWidgets.customAltertBox(
                      context,
                      state.message,
                      () {},
                    );
                  }
                },
              ),
            ],
            child: BlocBuilder<TeacherAssignmentBloc, TeacherAssignmentState>(
              builder: (context, state) {
                final List<AppFile> submissions =
                    (state is TeacherAssignmentLoaded) ? state.submissions : [];

                final Map<String, double> downloadProgress =
                    (state is TeacherAssignmentLoaded)
                    ? state.downloadProgress
                    : {};

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

                          final isDownloaded = (sub != null)
                              ? sub.isDownloaded
                              : false;

                          final downloading = (sub != null)
                              ? downloadProgress.containsKey(sub.id!)
                              : false;

                          final progress = (sub != null)
                              ? downloadProgress[sub.id!]
                              : null;

                          return CustomWidgets.studentSubmissionCard(
                            student: student,
                            submission: sub,
                            // icon: Icons.file_download_outlined,
                            onDownload: () =>
                                context.read<TeacherAssignmentBloc>().add(
                                  DownloadAssignmentSubmission(
                                    submission: sub!,
                                    className: cls.name,
                                  ),
                                ),
                            isDownloaded: isDownloaded,
                            downloading: downloading,
                            progress: progress,
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
    );
  }
}
