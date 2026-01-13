part of 'teacher.assignment_bloc.dart';

sealed class TeacherAssignmentEvent {}

final class LoadTeacherAssignments extends TeacherAssignmentEvent {
  final String classId;
  final String teacherId;
  LoadTeacherAssignments({required this.teacherId, required this.classId});
}

final class CreateAssignment extends TeacherAssignmentEvent {
  final String classId;
  final String teacherId;
  CreateAssignment({required this.teacherId, required this.classId});
}

final class UpdateAssignment extends TeacherAssignmentEvent{
  final String assignmentId;
  UpdateAssignment({required this.assignmentId});
}

final class DeleteAssignment extends TeacherAssignmentEvent {
  final String assignmentId;
  DeleteAssignment({required this.assignmentId});
} 
