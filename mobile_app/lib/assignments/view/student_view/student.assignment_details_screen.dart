import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/student_assignments/bloc/student.assignment_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/user/models/student.dart';

class StudentAssignmentDetailsScreen extends StatefulWidget {
  final Student student;
  final Assignment assignment;

  const StudentAssignmentDetailsScreen({
    super.key,
    required this.student,
    required this.assignment,
  });

  @override
  State<StudentAssignmentDetailsScreen> createState() =>
      _StudentAssignmentDetailsScreenState();
}

class _StudentAssignmentDetailsScreenState
    extends State<StudentAssignmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),

      body: BlocListener<StudentsAssignmentBloc, StudentsAssignmentState>(
        listener: (context, state) {
          if (state is StudentAssignmentSubmitError) {
            CustomWidgets.customAltertBox(context, state.message, () {
              context.read<StudentsAssignmentBloc>().add(
                LoadClassAssignments(student: widget.student),
              );
            });
          }

          if (state is StudentAssignmentSubmitSuccess) {
            CustomWidgets.customAltertBox(
              context,
              'Assignment submitted :)',
              () {
                context.read<StudentsAssignmentBloc>().add(
                  LoadClassAssignments(student: widget.student),
                );
              },
            );
          }
        },
        child: BlocBuilder<StudentsAssignmentBloc, StudentsAssignmentState>(
          builder: (context, state) {
            if (state is StudentAssignmentLoading) {
              return Center(child: CustomWidgets.customLoader());
            }

            final List<AppFile> submissions = (state is StudentAssignmentLoaded)
                ? state.submissions
                : [];

            // submission of the corresponding assignment
            AppFile? submission = submissions.firstWhereOrNull(
              (s) => s.ownerId == widget.assignment.id,
            );
            int submissionCount = submissions
                .where((s) => s.ownerId == widget.assignment.id)
                .length;

            return SingleChildScrollView(
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
                        // related subject of the corresponding assignment
                        final sub =
                            subjects.firstWhere(
                                  (s) => s.id == widget.assignment.subjectId,
                                )
                                as Subject;

                        return CustomWidgets.studentAssignmentCards(
                          detailed: true,
                          context: context,
                          assignment: widget.assignment,
                          subjectName: sub.name,
                          onTap: () {},
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
                    CustomWidgets.submissionDetailsForStudent(
                      widget.assignment,
                      submission,
                      count: submissionCount,
                    ),

                    const SizedBox(height: 15),

                    // submit assignment
                    Row(
                      children: [
                        Spacer(),
                        ElevatedButton(
                          onPressed: () async => _submit(
                            classId: widget.student.classId,
                            studentId: widget.student.id,
                            assignmentId: widget.assignment.id!,
                            oldSubmission: submission,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2AB3AA),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            (submission == null)
                                ? 'Submit Assignment'
                                : 'Resubmit Assignment',
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
            );
          },
        ),
      ),
    );
  }

  // submit assignment
  Future<void> _submit({
    required String classId,
    required String studentId,
    required String assignmentId,
    AppFile? oldSubmission,
  }) async {
    final bloc = context.read<StudentsAssignmentBloc>();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result == null) return;

    final file = result.files.single;

    bloc.add(
      SubmitAssignment(
        submision: file,
        studentId: studentId,
        classId: classId,
        assignmentId: assignmentId,
      ),
    );
  }
}
