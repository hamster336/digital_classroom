import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.impl.dart';
import 'package:mobile_app/submission/repository/submission_repo_impl.dart';

part 'teacher.assignment_event.dart';
part 'teacher.assignment_state.dart';

class TeacherAssignmentBloc
    extends Bloc<TeacherAssignmentEvent, TeacherAssignmentState> {
  final AssignmentRepoImpl assignmentRepo;
  final SubmissionRepoImpl submissionRepo;

  TeacherAssignmentBloc(this.assignmentRepo, this.submissionRepo)
    : super(TeacherAssignmentLoading()) {
    on<LoadTeacherAssignments>(_loadTeacherAssignment);
    on<RefreshAssignments>(_refreshAssignments);
    on<CreateAssignment>(_createAssignment);
    on<UpdateAssignment>(_updateAssignment);
    on<DeleteAssignment>(_deleteAssignment);
  }

  // cache asignments to prevent refetching each time the teacher navigates
  Map<String, List<Assignment>> cachedAssignemnts = {};
  Map<String, List<AppFile>> cachedSubmissions = {};

  // refresh assignments
  Future<void> _refreshAssignments(
    RefreshAssignments event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    final key = '${event.teacherId}-${event.classId}';

    try {
      final assignments = await assignmentRepo.loadTeachersAssignments(
        event.classId,
        event.teacherId,
      );
      final submissions = await submissionRepo.getSubmissionsForTeacher(
        event.classId,
        assignments.map((a) => a.id!).toList(),
      );
      cachedAssignemnts[key] = assignments;
      cachedSubmissions[key] = submissions;
      emit(
        TeacherAssignmentLoaded(
          assignments: assignments,
          submissions: submissions,
        ),
      );
    } catch (e) {
      emit(TeacherAssignmentLoadingError(message: e.toString()));
    }
  }

  // load assignmentso
  Future<void> _loadTeacherAssignment(
    LoadTeacherAssignments event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    final key = '${event.teacherId}-${event.classId}';

    if (cachedAssignemnts.containsKey(key)) {
      emit(
        TeacherAssignmentLoaded(
          assignments: cachedAssignemnts[key]!,
          submissions: cachedSubmissions[key]!,
        ),
      );
      return;
    }

    emit(TeacherAssignmentLoading());

    try {
      final assignments = await assignmentRepo.loadTeachersAssignments(
        event.classId,
        event.teacherId,
      );
      final submissions = await submissionRepo.getSubmissionsForTeacher(
        event.classId,
        assignments.map((a) => a.id!).toList(),
      );

      cachedAssignemnts[key] = assignments;
      cachedSubmissions[key] = submissions;
      emit(
        TeacherAssignmentLoaded(
          assignments: assignments,
          submissions: submissions,
        ),
      );
    } catch (e) {
      emit(TeacherAssignmentLoadingError(message: e.toString()));
    }
  }

  // particular assignment object lai edit garr ani purai list lai emit grr
  Future<void> _createAssignment(
    CreateAssignment event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    if (state is! TeacherAssignmentLoaded) return;

    final currentState = (state as TeacherAssignmentLoaded);

    emit(TeacherAssignmentLoading());

    try {
      await assignmentRepo.addAssignment(event.assignment);

      emit(CreateAssignmentSuccess());
    } catch (e) {
      emit(TeacherAssignmentLoadingError(message: e.toString()));
      emit(currentState);
    }
  }

  // delete assignment
  Future<void> _updateAssignment(
    UpdateAssignment event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    if (state is! TeacherAssignmentLoaded) return;

    final currentState = (state as TeacherAssignmentLoaded);

    emit(TeacherAssignmentLoading());

    try {
      await assignmentRepo.updateAssignment(event.assignment);
      emit(UpdateAssignmentSuccess());
    } catch (e) {
      emit(TeacherAssignmentLoadingError(message: e.toString()));
      emit(currentState);
    }
  }

  // delete assignment
  Future<void> _deleteAssignment(
    DeleteAssignment event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    if (state is! TeacherAssignmentLoaded) return;

    final currentState = (state as TeacherAssignmentLoaded);

    emit(TeacherAssignmentLoading());

    try {
      await assignmentRepo.deleteAssignment(event.assignmentId);
      emit(DeleteAssignmentSuccess());
      emit(currentState);
    } catch (e) {
      emit(TeacherAssignmentLoadingError(message: e.toString()));
      emit(currentState);
    }
  }
}
