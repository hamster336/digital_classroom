part of 'teacher.assignment_bloc.dart';

sealed class TeacherAssignmentEvent {}

final class LoadTeacherAssignments extends TeacherAssignmentEvent {
  final String classId;
  final String teacherId;
  LoadTeacherAssignments({required this.teacherId, required this.classId});
}

final class RefreshAssignments extends TeacherAssignmentEvent{
  final String classId;
  final String teacherId;
  RefreshAssignments({required this.teacherId, required this.classId});
}

final class CreateAssignment extends TeacherAssignmentEvent {
  final Assignment assignment;
  CreateAssignment({required this.assignment});
}

final class UpdateAssignment extends TeacherAssignmentEvent {
  final Assignment assignment;
  UpdateAssignment({required this.assignment});
}

final class DeleteAssignment extends TeacherAssignmentEvent {
  final String assignmentId;
  DeleteAssignment({required this.assignmentId});
}

final class DownloadAssignmentSubmission extends TeacherAssignmentEvent {
  final AppFile submission;
  String className;
  DownloadAssignmentSubmission({required this.submission, required this.className});
}