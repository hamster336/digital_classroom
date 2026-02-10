part of 'teacher.assignment_bloc.dart';

sealed class TeacherAssignmentState {}

final class TeacherAssignmentLoading extends TeacherAssignmentState {}

final class TeacherAssignmentLoaded extends TeacherAssignmentState {
  final List<Assignment> assignments;
  TeacherAssignmentLoaded({required this.assignments});
}

final class TeacherAssignmentLoadingError extends TeacherAssignmentState {
  final String message;
  TeacherAssignmentLoadingError({required this.message});
}

final class CreatedAssignment extends TeacherAssignmentState {}

final class UpdatedAssignment extends TeacherAssignmentState {}

final class DeletedAssignment extends TeacherAssignmentState {}

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
