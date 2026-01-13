part of 'teacher.assignment_bloc.dart';

sealed class TeacherAssignmentState {}

final class TeacherAssignmentLoading extends TeacherAssignmentState {}

final class TeacherAssignmentLoaded extends TeacherAssignmentState {
  final List<Assignment> assignments;
  TeacherAssignmentLoaded({required this.assignments});
}

final class TeacherAssignmentError extends TeacherAssignmentState {
  final String message;
  TeacherAssignmentError({required this.message});
}
