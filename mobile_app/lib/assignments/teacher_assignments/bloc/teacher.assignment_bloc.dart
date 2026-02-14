import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.impl.dart';

part 'teacher.assignment_event.dart';
part 'teacher.assignment_state.dart';

class TeacherAssignmentBloc
    extends Bloc<TeacherAssignmentEvent, TeacherAssignmentState> {
  final AssignmentRepoImpl repository;

  TeacherAssignmentBloc(this.repository) : super(TeacherAssignmentLoading()) {
    on<LoadTeacherAssignments>(_loadTeacherAssignment);
    on<RefreshAssignments>(_refreshAssignments);
    on<CreateAssignment>(_createAssignment);
    on<UpdateAssignment>(_updateAssignment);
    on<DeleteAssignment>(_deleteAssignment);
  }

  // cache asignments to prevent refetching each time the teacher navigates
  Map<String, List<Assignment>> cached = {};

  // refresh assignments
  Future<void> _refreshAssignments(
    RefreshAssignments event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    final key = '${event.teacherId}-${event.classId}';

    try {
      final assignments = await repository.loadTeachersAssignments(
        event.classId,
        event.teacherId,
      );
      cached[key] = assignments;
      emit(TeacherAssignmentLoaded(assignments: assignments));
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

    if (cached.containsKey(key)) {
      emit(TeacherAssignmentLoaded(assignments: cached[key]!));
      return;
    }

    emit(TeacherAssignmentLoading());

    try {
      final assignments = await repository.loadTeachersAssignments(
        event.classId,
        event.teacherId,
      );
      cached[key] = assignments;
      emit(TeacherAssignmentLoaded(assignments: assignments));
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
      await repository.addAssignment(event.assignment);

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
      await repository.updateAssignment(event.assignment);
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
      await repository.deleteAssignment(event.assignmentId);
      emit(DeleteAssignmentSuccess());
      emit(TeacherAssignmentLoaded(assignments: currentState.assignments));
    } catch (e) {
      emit(TeacherAssignmentLoadingError(message: e.toString()));
      emit(currentState);
    }
  }
}
