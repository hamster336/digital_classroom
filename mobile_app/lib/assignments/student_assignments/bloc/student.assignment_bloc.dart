import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.impl.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/submission/repository/submission_repo_impl.dart';
import 'package:mobile_app/user/models/student.dart';

part 'student.assignment_event.dart';
part 'student.assignment_state.dart';

class StudentsAssignmentBloc
    extends Bloc<StudentsAssignmentEvent, StudentsAssignmentState> {
  final AssignmentRepoImpl assignmentRepo;
  final SubmissionRepoImpl submissionRepo;

  StudentsAssignmentBloc({
    required this.assignmentRepo,
    required this.submissionRepo,
  }) : super(StudentAssignmentInitial()) {
    on<LoadClassAssignments>(_loadAssignments);
    on<FilterAssignments>(_filterAssignments);
    on<RefreshAssignments>(_refreshAssignments);
    on<SubmitAssignment>(_submitAssignment);
    // on<ResubmitAssignment>(_resubmitAssignment);
  }

  // refresh Assignments
  Future<void> _refreshAssignments(
    RefreshAssignments event,
    Emitter<StudentsAssignmentState> emit,
  ) async {
    if (state is! StudentAssignmentLoaded) return;

    final currentState = state as StudentAssignmentLoaded;

    try {
      final List<Assignment> assignments = await assignmentRepo
          .loadStudentsAssignments(
            event.student.classId,
            event.student.subjectIds,
          );
      final List<AppFile> submissions = await submissionRepo
          .getSubmissionsForStudent(event.student.id, event.student.classId);

      emit(
        currentState.copyWith(
          assignments: assignments,
          submissions: submissions,
        ),
      );
    } catch (ex) {
      emit(
        StudentAssignmentLoadingError(message: 'Failed to Load Assignments'),
      );
    }
  }

  // load assignments
  Future<void> _loadAssignments(
    LoadClassAssignments event,
    Emitter<StudentsAssignmentState> emit,
  ) async {
    emit(StudentAssignmentLoading());

    try {
      final List<Assignment> assignments = await assignmentRepo
          .loadStudentsAssignments(
            event.student.classId,
            event.student.subjectIds,
          );
      final List<AppFile> submissions = await submissionRepo
          .getSubmissionsForStudent(event.student.id, event.student.classId);

      emit(
        StudentAssignmentLoaded(
          assignments: assignments,
          submissions: submissions,
        ),
      );
    } catch (ex) {
      emit(
        StudentAssignmentLoadingError(message: 'Failed to Load Assignments'),
      );
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

  // submite assignment
  Future<void> _submitAssignment(
    SubmitAssignment event,
    Emitter<StudentsAssignmentState> emit,
  ) async {
    emit(StudentAssignmentLoading());

    try {
      await submissionRepo.submitAssignment(
        submission: event.submision,
        classId: event.classId,
        studentId: event.studentId,
        assignmentId: event.assignmentId,
      );
      emit(StudentAssignmentSubmitSuccess());
    } catch (e) {
      emit(StudentAssignmentSubmitError(message: e.toString()));
    }
  }
}
