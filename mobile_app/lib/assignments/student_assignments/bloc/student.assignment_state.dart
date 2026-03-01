part of 'student.assignment_bloc.dart';

sealed class StudentsAssignmentState {}

final class StudentAssignmentInitial extends StudentsAssignmentState {}

final class StudentAssignmentLoading extends StudentsAssignmentState {}

final class StudentAssignmentLoaded extends StudentsAssignmentState {
  final List<Assignment> assignments;
  final List<AppFile> submissions;
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
    final submittedAssignmentIds = submissions.map((s) => s.ownerId).toSet();

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
                  a.dueDate.isAfter(now),
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
    // set  of submission ids for fast lookup
    final submittedAssignmentIds = submissions.map((s) => s.ownerId).toSet();

    return assignments
        .where((a) => !submittedAssignmentIds.contains(a.id))
        .length;
  }

  StudentAssignmentLoaded copyWith({
    List<Assignment>? assignments,
    List<AppFile>? submissions,
    AssignmentFilter? filter,
  }) {
    return StudentAssignmentLoaded(
      assignments: assignments ?? this.assignments,
      submissions: submissions ?? this.submissions,
      filter: filter ?? this.filter,
    );
  }
}

final class StudentAssignmentLoadingError extends StudentsAssignmentState {
  final String message;
  StudentAssignmentLoadingError({required this.message});
}

final class StudentAssignmentSubmitError extends StudentsAssignmentState {
  final String message;
  StudentAssignmentSubmitError({required this.message});
}

final class StudentAssignmentSubmitSuccess extends StudentsAssignmentState {}
