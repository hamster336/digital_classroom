import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/assignments/view/teacher_view/assignment_form.dart';
import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class TeacherAssignmentView extends StatefulWidget {
  final String teacherId;
  final Classroom cls;
  const TeacherAssignmentView({
    super.key,
    required this.cls,
    required this.teacherId,
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
        teacherId: widget.teacherId,
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
                  builder: (_) => AssignmentForm(
                    cls: widget.cls,
                    teacherId: widget.teacherId,
                  ),
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
                  if (state is DeletedAssignment) {
                    CustomWidgets.customAltertBox(
                      context,
                      'Assignment deleted successfully.',
                      () => context.read<TeacherAssignmentBloc>().add(
                        RefreshAssignments(
                          teacherId: widget.teacherId,
                          classId: widget.cls.id,
                        ),
                      ),
                    );
                  }
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<TeacherAssignmentBloc>();
                    bloc.add(
                      RefreshAssignments(
                        teacherId: widget.teacherId,
                        classId: widget.cls.id,
                      ),
                    );

                    await bloc.stream.firstWhere(
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
                          if (state is! TeacherAssignmentLoaded) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final assignments = state.assignments;

                          if (assignments.isEmpty) {
                            return Center(
                              child: const Text(
                                'No assignments available',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: assignments.length,
                            itemBuilder: (context, index) {
                              return CustomWidgets.teachersAssignmentCards(
                                context: context,
                                assignment: assignments[index],
                                onEdit: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AssignmentForm(
                                      initialAssignment: assignments[index],
                                      cls: widget.cls,
                                      teacherId: widget.teacherId,
                                    ),
                                  ),
                                ),
                                onDelete: () async =>
                                    _onDelete(assignments[index].id!),
                              );
                            },
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Assingment',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Are you sure you want to delete this assignment?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                context.read<TeacherAssignmentBloc>().add(
                  DeleteAssignment(assignmentId: assignmentId),
                );
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
