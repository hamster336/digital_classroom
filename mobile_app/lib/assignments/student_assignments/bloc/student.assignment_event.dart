part of 'student.assignment_bloc.dart';

sealed class StudentsAssignmentEvent {}

final class LoadClassAssignments extends StudentsAssignmentEvent {
  final Student student;
  LoadClassAssignments({required this.student});
}

final class RefreshAssignments extends StudentsAssignmentEvent {
  final Student student;
  RefreshAssignments({required this.student});
}

final class FilterAssignments extends StudentsAssignmentEvent {
  final AssignmentFilter filter;
  FilterAssignments({required this.filter});
}

final class SubmitAssignment extends StudentsAssignmentEvent {
  final PlatformFile submision;
  final String studentId;
  final String classId;
  final String assignmentId;
  
  SubmitAssignment({
    required this.submision,
    required this.studentId,
    required this.classId,
    required this.assignmentId,
  });
}

final class ResubmitAssignment extends StudentsAssignmentEvent {
  final PlatformFile file;
  final AppFile oldSubmission;

  ResubmitAssignment({required this.file, required this.oldSubmission});
}
