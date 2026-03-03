part of 'submission_bloc.dart';

sealed class SubmissionEvent {}

final class LoadStudents extends SubmissionEvent {
  final String classId;
  final String subjectId;

  LoadStudents({required this.classId, required this.subjectId});
}

final class RefreshStudents extends SubmissionEvent {
  final String classId;
  final String subjectId;

  RefreshStudents({required this.classId, required this.subjectId});
}

