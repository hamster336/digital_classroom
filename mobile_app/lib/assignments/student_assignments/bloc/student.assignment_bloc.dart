import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/submission/model/submission.dart';
import 'package:mobile_app/submission/repository/submission_repo.dart';
import 'package:mobile_app/user/models/student.dart';

part 'student.assignment_event.dart';
part 'student.assignment_state.dart';

class StudentsAssignmentBloc
    extends Bloc<StudentsAssignmentEvent, StudentsAssignmentState> {
  final AssignmentRepo assignmentRepo;
  final SubmissionRepo submissionRepo;
  StudentsAssignmentBloc({
    required this.assignmentRepo,
    required this.submissionRepo,
  }) : super(StudentAssignmentLoading()) {
    on<LoadClassAssignments>(_loadAssignments);
    on<FilterAssignments>(_filterAssignments);
  }

  // load assignments
  Future<void> _loadAssignments(
    LoadClassAssignments event,
    Emitter<StudentsAssignmentState> emit,
  ) async {
    emit(StudentAssignmentLoading());

    try {
      final List<Assignment> assignments = assignmentRepo.fetchAssignments();
      final List<Submission> submissions = submissionRepo.fetchSubmissions(
        event.student.id,
      );
      emit(
        StudentAssignmentLoaded(
          assignments: assignments,
          submissions: submissions,
        ),
      );
    } catch (ex) {
      emit(StudentAssignmentError(message: 'Failed to Load Assignments'));
    }
  }

  // filter assignments
  Future<void> _filterAssignments(
    FilterAssignments event,
    Emitter<StudentsAssignmentState> emit,
  ) async {
    if (state is! StudentAssignmentLoaded) return;

    final current = state as StudentAssignmentLoaded;
    emit(current.copyWith(filter: event.filter));
  }
}
