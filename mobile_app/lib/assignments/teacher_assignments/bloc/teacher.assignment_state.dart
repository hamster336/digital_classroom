part of 'teacher.assignment_bloc.dart';

sealed class TeacherAssignmentState {}

final class TeacherAssignmentLoading extends TeacherAssignmentState {}

final class TeacherAssignmentLoaded extends TeacherAssignmentState {
  final List<Assignment> assignments;
  final List<AppFile> submissions;

  TeacherAssignmentLoaded({
    required this.assignments,
    required this.submissions,
  });
}

final class TeacherAssignmentLoadingError extends TeacherAssignmentState {
  final String message;
  TeacherAssignmentLoadingError({required this.message});
}

final class CreateAssignmentSuccess extends TeacherAssignmentState {}

final class UpdateAssignmentSuccess extends TeacherAssignmentState {}

final class DeleteAssignmentSuccess extends TeacherAssignmentState {}

final class CreateAssignmentError extends TeacherAssignmentState {
  final String message;

  CreateAssignmentError({required this.message});
}

final class UpdateAssignmentError extends TeacherAssignmentState {
  final String message;

  UpdateAssignmentError({required this.message});
}

final class DeleteAssignmentError extends TeacherAssignmentState {
  final String message;
  DeleteAssignmentError({required this.message});
}
