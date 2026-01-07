import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/shared/required_enums.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  AssignmentBloc() : super(AssignmentInitial()) {
    on<LoadAssignments>(_loadAssignments);
    on<FilterAssignments>(_filterAssignments);
  }

  // load assignments
  Future<void> _loadAssignments(
    LoadAssignments event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentLoading());

    try {
      final List<Assignment> list = [
        Assignment(
          id: '1',
          title: 'AI lab report',
          description:
              'All the students are expected to submit their lab report on AI by 10th of January.',
          issuedAt: DateTime(2026, 01, 06, 12, 23),
          dueDate: DateTime(2026, 01, 10, 08, 00),
          priority: AssignmentPriority.medium,
          submitted: false,
        ),
        Assignment(
          id: '1',
          title: 'Minor Project Proposal submission',
          description:
              'All the students are expected to submit minor project proposal by 6th of January to the Library of School of Engineering.',
          issuedAt: DateTime(2025, 12, 25, 10, 00),
          dueDate: DateTime(2026, 01, 06, 15, 00),
          priority: AssignmentPriority.urgent,
          submitted: false,
        ),
        Assignment(
          id: '1',
          title: 'Economics Numericals',
          description:
              'I will provide some passed years question papers from different universities. Students will have to solve all the numerical questions that are covered in your syllabus and submit them by 01 Feb.',
          issuedAt: DateTime(2026, 01, 02, 18, 47),
          dueDate: DateTime(2026, 02, 01, 14, 30),
          priority: AssignmentPriority.normal,
          submitted: false,
        ),
        Assignment(
          id: '1',
          title: 'DBMS lab report',
          description:
              'All the students are expected to submit their lab report on DBMS by 5th of January.',
          issuedAt: DateTime(2025, 12, 25, 13, 10),
          dueDate: DateTime(2026, 01, 5, 15, 00),
          priority: AssignmentPriority.normal,
          submitted: true,
        ),
      ];
      emit(AssignmentLoaded(assignments: list));
    } catch (ex) {
      emit(AssignmentError(message: 'Failed to Load Assignments'));
    }
  }

  // filter assignments
  Future<void> _filterAssignments(
    FilterAssignments event,
    Emitter<AssignmentState> emit,
  ) async {
    if (state is! AssignmentLoaded) return;

    final current = state as AssignmentLoaded;
    emit(current.copyWith(filter: event.filter));
  }
}
