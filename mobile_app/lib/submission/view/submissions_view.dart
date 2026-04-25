import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/submission/bloc/submission_bloc.dart';

class SubmissionsView extends StatefulWidget {
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
  State<SubmissionsView> createState() => _SubmissionsViewState();
}

class _SubmissionsViewState extends State<SubmissionsView> {
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
            RefreshAssignments(
              teacherId: widget.subject.teacherId,
              classId: widget.cls.id,
            ),
          );
          subBloc.add(
            RefreshStudents(
              classId: widget.cls.id,
              subjectId: widget.subject.id,
            ),
          );

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
                        teacherId: widget.subject.teacherId,
                        classId: widget.cls.id,
                      ),
                    );
                  }

                  if (state is GradeSubmissionError) {
                    CustomWidgets.customAltertBox(
                      context,
                      state.message,
                      () {},
                    );
                  }
                  if (state is GradeSubmissionSuccess) {
                    context.read<TeacherAssignmentBloc>().add(
                      RefreshAssignments(
                        teacherId: widget.subject.teacherId,
                        classId: widget.cls.id,
                      ),
                    );

                    context.read<SubmissionBloc>().add(
                      RefreshStudents(
                        classId: widget.cls.id,
                        subjectId: widget.subject.id,
                      ),
                    );
                    CustomWidgets.customAltertBox(
                      context,
                      'Assignment graded successfully.',
                      () {},
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
                if (state is TeacherAssignmentLoading) {
                  return CustomWidgets.customLoader();
                }

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
                                (s.ownerId == widget.assignmentId),
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
                            onDownload: () =>
                                context.read<TeacherAssignmentBloc>().add(
                                  DownloadSubmission(
                                    submission: sub!,
                                    className: widget.cls.name,
                                  ),
                                ),
                            isDownloaded: isDownloaded,
                            downloading: downloading,
                            progress: progress,
                            onGrade: () async {
                              if (sub == null) return;
                              final bloc = context
                                  .read<TeacherAssignmentBloc>();

                              if (!isDownloaded) {
                                bloc.add(
                                  DownloadSubmission(
                                    submission: sub,
                                    className: widget.cls.name,
                                  ),
                                );
                                return;
                              }

                              final result = await showGradeDialog(
                                initialScore: sub.score,
                                initialRemarks: sub.remarks,
                              );

                              if (result == null) return;

                              final score = result['score'];
                              final remarks = result['remarks'];

                              log('Score: $score \n Remarks: $remarks');

                              bloc.add(
                                GradeSubmission(
                                  submissionId: sub.id!,
                                  score: score,
                                  remarks: remarks,
                                ),
                              );
                            },
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

  // grade submission
  Future<Map<String, dynamic>?> showGradeDialog({
    double? initialScore,
    String? initialRemarks,
  }) async {
    final scoreController = TextEditingController(
      text: initialScore != null ? initialScore.toString() : '',
    );

    final remarksController = TextEditingController(text: initialRemarks ?? '');

    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isChanged() {
              final currentScore = scoreController.text.trim();
              final currentRemarks = remarksController.text.trim();

              final initialScoreStr = initialScore != null
                  ? initialScore.toString()
                  : '';
              final initialRemarksStr = initialRemarks ?? '';

              return currentScore != initialScoreStr ||
                  currentRemarks != initialRemarksStr;
            }

            return AlertDialog(
              title: const Text('Grade Submission'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: scoreController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Score (0 - 10)',
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter score';
                        }

                        final score = double.tryParse(value);
                        if (score == null) return 'Invalid number';
                        if (score < 0 || score > 10) {
                          return 'Score must be 0–10';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: remarksController,
                      maxLines: null,
                      decoration: const InputDecoration(labelText: 'Remarks'),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: isChanged()
                      ? () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context, {
                              'score': double.parse(
                                scoreController.text.trim(),
                              ),
                              'remarks': remarksController.text.trim(),
                            });
                          }
                        }
                      : null, // disabled if not changed
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
