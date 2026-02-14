part of 'student.assignment_bloc.dart';

sealed class StudentsAssignmentEvent {}

final class LoadClassAssignments extends StudentsAssignmentEvent {
  final Student student;
  LoadClassAssignments({required this.student});
}

final class FilterAssignments extends StudentsAssignmentEvent {
  final AssignmentFilter filter;
  FilterAssignments({required this.filter});
}
