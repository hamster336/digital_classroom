part of 'student.assignment_bloc.dart';

sealed class StudentsAssignmentEvent {}

// common events for students and teachers
final class LoadClassAssignments extends StudentsAssignmentEvent {
  final String studentId;
  LoadClassAssignments({required this.studentId});
}

// events for teachers
final class CreateAssignment extends StudentsAssignmentEvent {}

final class DeleteAssignment extends StudentsAssignmentEvent {}

// events for students
final class FilterAssignments extends StudentsAssignmentEvent {
  final AssignmentFilter filter;
  FilterAssignments({required this.filter});
}
