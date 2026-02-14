part of 'submission_bloc.dart';

sealed class SubmissionEvent {}

// for students
final class SubmitAssignment extends SubmissionEvent {
  final Submission submision;
  SubmitAssignment({required this.submision});
}

final class UpdateAssignment extends SubmissionEvent {
  final Submission submision;
  UpdateAssignment({required this.submision});
}

final class LoadStudentSubmissions extends SubmissionEvent {
  final String studentId;
  LoadStudentSubmissions({required this.studentId});
}

final class LoadSingleSubmission extends SubmissionEvent {
  final String studentId;
  final String assignmentId;

  LoadSingleSubmission({required this.studentId, required this.assignmentId});
}

// for teacher
final class LoadAssignmentSubmission extends SubmissionEvent {
  final String assignmentId;
  LoadAssignmentSubmission({required this.assignmentId});
}
