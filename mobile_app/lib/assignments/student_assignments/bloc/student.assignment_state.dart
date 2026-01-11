part of 'student.assignment_bloc.dart';

sealed class StudentsAssignmentState {}

final class StudentAssignmentLoading extends StudentsAssignmentState {}

final class StudentAssignmentLoaded extends StudentsAssignmentState {
  final List<Assignment> assignments;
  final List<Submission> submissions;
  final AssignmentFilter filter;

  StudentAssignmentLoaded({
    required this.assignments,
    required this.submissions,
    this.filter = AssignmentFilter.pending,
  });

  // get the filtered assignments
  List<Assignment> showAssignments() {
    final now = DateTime.now();

    // set  of submission ids for fast lookup
    final submittedAssignmentIds = submissions
        .map((s) => s.assignmentId)
        .toSet();

    switch (filter) {
      case AssignmentFilter.completed:
        return assignments
            .where((a) => submittedAssignmentIds.contains(a.id))
            .toList();
      case AssignmentFilter.pending:
        return assignments
            .where(
              (a) =>
                  !submittedAssignmentIds.contains(a.id) &&
                  !a.dueDate.isBefore(now),
            )
            .toList();
      case AssignmentFilter.overdue:
        return assignments
            .where(
              (a) =>
                  !submittedAssignmentIds.contains(a.id) &&
                  a.dueDate.isBefore(now),
            )
            .toList();
    }
  }

  // get total number of assignments
  int get totalCount => assignments.length;

  // get no of remaining assignments
  int get pendingCount {
    final now = DateTime.now();

    // set  of submission ids for fast lookup
    final submittedAssignmentIds = submissions
        .map((s) => s.assignmentId)
        .toSet();

    return assignments
        .where((a) => !submittedAssignmentIds.contains(a.id))
        .length;
  }

  StudentAssignmentLoaded copyWith({
    List<Assignment>? assignments,
    List<Submission>? submissions,
    AssignmentFilter? filter,
  }) {
    return StudentAssignmentLoaded(
      assignments: assignments ?? this.assignments,
      submissions: submissions ?? this.submissions,
      filter: filter ?? this.filter,
    );
  }
}

final class StudentAssignmentError extends StudentsAssignmentState {
  final String message;
  StudentAssignmentError({required this.message});
}
