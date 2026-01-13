import 'package:flutter/material.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class TeacherAssignmentDetailScreen extends StatelessWidget {
  final Assignment assignment;
  const TeacherAssignmentDetailScreen({super.key, required this.assignment});

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
              CustomWidgets.teachersAssignmentCards(
                context,
                assignment,
                detailed: true,
              ),

              const SizedBox(height: 15),

              // submission details
              const Text(
                'SUBMISSION DETAILS:',
                style: TextStyle(color: Colors.black45),
              ),
              const SizedBox(height: 5),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
