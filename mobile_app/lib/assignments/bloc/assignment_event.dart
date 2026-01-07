part of 'assignment_bloc.dart';

sealed class AssignmentEvent {}

// common events for students and teachers
final class LoadAssignments extends AssignmentEvent {}

// events for teachers
final class CreateAssignment extends AssignmentEvent {}

final class DeleteAssignment extends AssignmentEvent {}

// events for students
final class FilterAssignments extends AssignmentEvent {
  final AssignmentFilter filter;
  FilterAssignments({required this.filter});
}

final class SubmitAssignment extends AssignmentEvent {}
