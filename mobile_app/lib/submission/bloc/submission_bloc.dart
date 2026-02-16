import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/submission/model/submission.dart';
import 'package:mobile_app/submission/repository/submission_repo_impl.dart';

part 'submission_event.dart';
part 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final SubmissionRepoImpl repository;

  SubmissionBloc(this.repository) : super(SubmissionsLoading()) {
    on<LoadStudentSubmissions>(_loadStudentSubmissions);
    on<SubmitAssignment>(_submitAssignment);
    on<UpdateAssignment>(_updateAssignment);
    on<LoadSingleSubmission>(_loadSingleSubmissions);
    on<LoadAssignmentSubmission>(_loadAssignmentSubmission);
  }

  /// FOR STUDENT

  // load all submissions
  Future<void> _loadStudentSubmissions(
    LoadStudentSubmissions event,
    Emitter<SubmissionState> emit,
  ) async {}

  // submit assignment
  Future<void> _submitAssignment(
    SubmitAssignment event,
    Emitter<SubmissionState> emit,
  ) async {}

  // update Assignment
  Future<void> _updateAssignment(
    UpdateAssignment event,
    Emitter<SubmissionState> emit,
  ) async {}

  // Load submission of a single assignment
  Future<void> _loadSingleSubmissions(
    LoadSingleSubmission event,
    Emitter<SubmissionState> emit,
  ) async {}

  /// FOR TEACHER

  // load all submissions
  Future<void> _loadAssignmentSubmission(
    LoadAssignmentSubmission event,
    Emitter<SubmissionState> emit,
  ) async {}
}
