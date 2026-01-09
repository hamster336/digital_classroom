part of 'assignment_bloc.dart';

sealed class AssignmentState {}

final class AssignmentLoading extends AssignmentState {}

final class AssignmentLoaded extends AssignmentState {
  final List<Assignment> assignments;
  final AssignmentFilter filter;

  AssignmentLoaded({
    required this.assignments,
    this.filter = AssignmentFilter.pending,
  });

  List<Assignment> get displayAssignments {
    switch (filter) {
      case AssignmentFilter.pending:
        final list = assignments
            .where(
              (a) =>
                  (a.submitted == false) && DateTime.now().isBefore(a.dueDate),
            )
            .toList();
        return list;
      case AssignmentFilter.completed:
        final list = assignments.where((a) => a.submitted == true).toList();
        return list;
      case AssignmentFilter.overdue:
        final list = assignments
            .where(
              (a) =>
                  (a.submitted == false) && a.dueDate.isBefore(DateTime.now()),
            )
            .toList();
        return list;
    }
  }

  int get totalCount => assignments.length;

  int get pendingCount =>
      assignments.where((a) => (a.submitted == false)).length;

  AssignmentLoaded copyWith({
    List<Assignment>? assignments,
    AssignmentFilter? filter,
  }) {
    return AssignmentLoaded(
      assignments: assignments ?? this.assignments,
      filter: filter ?? this.filter,
    );
  }
}

final class AssignmentError extends AssignmentState {
  final String message;
  AssignmentError({required this.message});
}
