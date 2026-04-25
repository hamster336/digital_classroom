import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/assignments/view/teacher_view/assignment_form.dart';
import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/home/bloc/teachers_dashboard_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/user/models/teacher.dart';

class TeacherAssignmentView extends StatefulWidget {
  final Teacher teacher;
  final Classroom cls;

  const TeacherAssignmentView({
    super.key,
    required this.cls,
    required this.teacher,
  });

  @override
  State<TeacherAssignmentView> createState() => _TeacherAssignmentViewState();
}

class _TeacherAssignmentViewState extends State<TeacherAssignmentView> {
  BuildContext? dialogContext;

  @override
  void initState() {
    super.initState();
    context.read<TeacherAssignmentBloc>().add(
      LoadTeacherAssignments(
        teacherId: widget.teacher.id,
        classId: widget.cls.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Assignments')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // create assignment button
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AssignmentForm(cls: widget.cls, teacher: widget.teacher),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2AB3AA),
                foregroundColor: Colors.white,
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.add),
                  const Text(
                    'Create Assignment',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // show assignments
            Expanded(
              child: BlocListener<TeacherAssignmentBloc, TeacherAssignmentState>(
                listener: (context, state) {
                  if (state is DeleteAssignmentError) {
                    CustomWidgets.customAltertBox(
                      context,
                      state.message,
                      () {},
                    );
                  }

                  // for delete operation, create and update will occure in another screen
                  if (state is DeleteAssignmentSuccess) {
                    CustomWidgets.customAltertBox(
                      context,
                      'Assignment deleted successfully.',
                      () {
                        context.read<DashboardBloc>().add(
                          LoadActiveAssignmentCount(
                            teacherId: widget.teacher.id,
                          ),
                        );

                        context.read<TeacherAssignmentBloc>().add(
                          RefreshAssignments(
                            teacherId: widget.teacher.id,
                            classId: widget.cls.id,
                          ),
                        );

                        context.read<UpcomingBloc>().add(
                          RefreshEvents(subjectIds: widget.teacher.subjectIds),
                        );
                      },
                    );
                  }
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    final assignmentBloc = context
                        .read<TeacherAssignmentBloc>();
                    final upcomingBloc = context.read<UpcomingBloc>();

                    assignmentBloc.add(
                      RefreshAssignments(
                        teacherId: widget.teacher.id,
                        classId: widget.cls.id,
                      ),
                    );

                    upcomingBloc.add(
                      RefreshEvents(subjectIds: widget.teacher.subjectIds),
                    );

                    await assignmentBloc.stream.firstWhere(
                      (state) =>
                          state is TeacherAssignmentLoaded ||
                          state is TeacherAssignmentLoadingError,
                    );
                  },
                  child:
                      BlocBuilder<
                        TeacherAssignmentBloc,
                        TeacherAssignmentState
                      >(
                        builder: (context, state) {
                          if (state is TeacherAssignmentLoading) {
                            return CustomWidgets.customLoader();
                          }

                          if (state is TeacherAssignmentLoaded) {
                            final assignments = state.assignments;

                            if (assignments.isEmpty) {
                              return CustomWidgets.customScrollableText(
                                context,
                                'No assignments available',
                              );
                            }

                            return ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: assignments.length,
                              itemBuilder: (context, index) {
                                return BlocBuilder<SubjectBloc, SubjectState>(
                                  builder: (context, state) {
                                    final subjects = (state is SubjectLoaded)
                                        ? state.subjects
                                        : [];

                                    final sub =
                                        subjects.firstWhere(
                                              (s) =>
                                                  s.id ==
                                                  assignments[index].subjectId,
                                            )
                                            as Subject;

                                    return CustomWidgets.teachersAssignmentCards(
                                      context: context,
                                      assignment: assignments[index],
                                      subject: sub,
                                      cls: widget.cls,
                                      onEdit: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AssignmentForm(
                                            initialAssignment:
                                                assignments[index],
                                            cls: widget.cls,
                                            teacher: widget.teacher,
                                          ),
                                        ),
                                      ),
                                      onDelete: () async =>
                                          _onDelete(assignments[index].id!),
                                    );
                                  },
                                );
                              },
                            );
                          }

                          return CustomWidgets.customScrollableText(
                            context,
                            'Error occured :(\nSwipe down to refresh.',
                          );
                        },
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // delete assignment
  Future<void> _onDelete(String assignmentId) async {
    final bloc = context.read<TeacherAssignmentBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return CustomWidgets.customConformationBox(
          context: context,
          title: 'Delete Assingment',
          content: 'Are you sure you want to delete this assignment?',
          onConfirm: () async {
            Navigator.pop(context);
            bloc.add(
              DeleteAssignment(assignmentId: assignmentId),
            );
          },
        );
      },
    );
  }
}
