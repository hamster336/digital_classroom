import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/student_assignments/bloc/student.assignment_bloc.dart';
import 'package:mobile_app/assignments/view/student_view/student.assignment_details_screen.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/user/models/student.dart';

class StudentAssignmentView extends StatefulWidget {
  final Student student;
  const StudentAssignmentView({super.key, required this.student});

  @override
  State<StudentAssignmentView> createState() => _StudentAssignmentViewState();
}

class _StudentAssignmentViewState extends State<StudentAssignmentView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: const Text('Assignments')),

      body: BlocListener<StudentsAssignmentBloc, StudentsAssignmentState>(
        listener: (context, state) {
          if (state is StudentAssignmentLoadingError) {
            CustomWidgets.customAltertBox(context, state.message, () {});
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            final assignmentBloc = context.read<StudentsAssignmentBloc>();
            final upcomingBloc = context.read<UpcomingBloc>();

            assignmentBloc.add(RefreshAssignments(student: widget.student));
            upcomingBloc.add(
              RefreshEvents(subjectIds: widget.student.subjectIds),
            );

            await assignmentBloc.stream.firstWhere(
              (state) =>
                  state is StudentAssignmentLoaded ||
                  state is StudentAssignmentLoadingError,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // total and pending assignments count
                BlocBuilder<StudentsAssignmentBloc, StudentsAssignmentState>(
                  builder: (context, state) {
                    int pending = 0;
                    int total = 0;

                    if (state is StudentAssignmentLoaded) {
                      pending = state.pendingCount;
                      total = state.totalCount;
                    }

                    return Text(
                      'Pending $pending . Total $total',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    );
                  },
                ),

                SizedBox(height: size.height * 0.01),

                // filter buttons
                BlocBuilder<StudentsAssignmentBloc, StudentsAssignmentState>(
                  builder: (context, state) {
                    final loaded = (state is StudentAssignmentLoaded)
                        ? true
                        : false;

                    final currentFilter = (state is StudentAssignmentLoaded)
                        ? state.filter
                        : AssignmentFilter.pending;

                    return Row(
                      children: [
                        CustomWidgets.assignmentFilterButton(
                          label: 'Pending',
                          isSelected: currentFilter == AssignmentFilter.pending,
                          onTap: (!loaded)
                              ? () {}
                              : () {
                                  context.read<StudentsAssignmentBloc>().add(
                                    FilterAssignments(
                                      filter: AssignmentFilter.pending,
                                    ),
                                  );
                                },
                        ),
                        const SizedBox(width: 5),
                        CustomWidgets.assignmentFilterButton(
                          label: 'Overdue',
                          isSelected: currentFilter == AssignmentFilter.overdue,
                          onTap: (!loaded)
                              ? () {}
                              : () {
                                  context.read<StudentsAssignmentBloc>().add(
                                    FilterAssignments(
                                      filter: AssignmentFilter.overdue,
                                    ),
                                  );
                                },
                        ),
                        const SizedBox(width: 5),
                        CustomWidgets.assignmentFilterButton(
                          label: 'Completed',
                          isSelected:
                              currentFilter == AssignmentFilter.completed,
                          onTap: (!loaded)
                              ? () {}
                              : () {
                                  context.read<StudentsAssignmentBloc>().add(
                                    FilterAssignments(
                                      filter: AssignmentFilter.completed,
                                    ),
                                  );
                                },
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: size.height * 0.01),

                // show the assignments
                Expanded(
                  child:
                      BlocBuilder<
                        StudentsAssignmentBloc,
                        StudentsAssignmentState
                      >(
                        builder: (context, assignmentState) {
                          if (assignmentState is StudentAssignmentLoading) {
                            return CustomWidgets.customLoader();
                          }

                          if (assignmentState is StudentAssignmentLoaded) {
                            final assignments = assignmentState
                                .showAssignments();

                            if (assignments.isEmpty) {
                              return CustomWidgets.customScrollableText(
                                context,
                                'No assignments available',
                              );
                            }

                            return ListView.builder(
                              itemCount: assignments.length,
                              itemBuilder: (_, index) {
                                return BlocBuilder<SubjectBloc, SubjectState>(
                                  builder: (context, state) {
                                    final assignment = assignments[index];
                                    final subjects = (state is SubjectLoaded)
                                        ? state.subjects
                                        : [];

                                    final sub =
                                        subjects.firstWhere(
                                              (s) =>
                                                  s.id == assignment.subjectId,
                                            )
                                            as Subject;

                                    return CustomWidgets.studentAssignmentCards(
                                      context: context,
                                      assignment: assignments[index],
                                      subjectName: sub.name,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              StudentAssignmentDetailsScreen(
                                                student: widget.student,
                                                assignment: assignment,
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                          return CustomWidgets.customScrollableText(
                            context,
                            'Error Occured :(\nSwipe down to refresh.',
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
