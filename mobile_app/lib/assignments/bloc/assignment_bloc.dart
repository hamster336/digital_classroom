import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.dart';
import 'package:mobile_app/shared/required_enums.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  AssignmentBloc() : super(AssignmentLoading()) {
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
      final List<Assignment> list = AssignmentRepo().getAssignments;
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
