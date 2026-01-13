import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class TeacherAssignmentView extends StatefulWidget {
  final String teacherId;
  final String classId;
  const TeacherAssignmentView({
    super.key,
    required this.classId,
    required this.teacherId,
  });

  @override
  State<TeacherAssignmentView> createState() => _TeacherAssignmentViewState();
}

class _TeacherAssignmentViewState extends State<TeacherAssignmentView> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherAssignmentBloc>().add(
      LoadTeacherAssignments(
        teacherId: widget.teacherId,
        classId: widget.classId,
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
            ElevatedButton(
              onPressed: () {},
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
            Expanded(
              child: BlocBuilder<TeacherAssignmentBloc, TeacherAssignmentState>(
                builder: (context, state) {
                  if (state is! TeacherAssignmentLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final assignments = state.assignments;

                  if (assignments.isEmpty) {
                    return Center(
                      child: const Text(
                        'No assignments available',
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      return CustomWidgets.teachersAssignmentCards(
                        context,
                        assignments[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
