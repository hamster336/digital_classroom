part of 'submission_bloc.dart';

sealed class SubmissionState {}

final class SubmissionInitial extends SubmissionState {}

final class LoadingStudents extends SubmissionState {}

final class StudentsLoaded extends SubmissionState {
  final List<ClassStudents> students;

  StudentsLoaded({required this.students});
}

final class StudentsLoadingError extends SubmissionState {
  final String message;
  StudentsLoadingError({required this.message});
}
