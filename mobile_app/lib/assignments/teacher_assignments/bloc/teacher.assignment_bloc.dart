import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.dart';

part 'teacher.assignment_event.dart';
part 'teacher.assignment_state.dart';

class TeacherAssignmentBloc extends Bloc<TeacherAssignmentEvent, TeacherAssignmentState> {
  final AssignmentRepo repository;
  TeacherAssignmentBloc(this.repository) : super(TeacherAssignmentLoading()) {
    on<LoadTeacherAssignments>(_loadTeacherAssignment);
    on<CreateAssignment>(_createAssignment);
    on<UpdateAssignment>(_updateAssignment);
    on<DeleteAssignment>(_deleteAssignment);
  }

  Future<void> _loadTeacherAssignment(LoadTeacherAssignments event, Emitter<TeacherAssignmentState> emit) async{
    emit(TeacherAssignmentLoading());

    try{
      final assignments = repository.fetchTeachersAssignment(event.teacherId, event.classId);
      emit(TeacherAssignmentLoaded(assignments: assignments));
    } catch (e) {
      emit(TeacherAssignmentError(message: e.toString()));
    }
  }

  // particular assignment object lai edit garr ani purai list lai amit grr
  Future<void> _createAssignment(CreateAssignment event, Emitter<TeacherAssignmentState> emit) async{
  }

  Future<void> _updateAssignment(UpdateAssignment event, Emitter<TeacherAssignmentState> emit) async{
  }

  Future<void> _deleteAssignment(DeleteAssignment event, Emitter<TeacherAssignmentState> emit) async{
  }
}
