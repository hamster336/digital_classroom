import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/classroom/model/classroom.dart';

import 'package:mobile_app/classroom/repository/classroom_repo.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final ClassroomRepo repository;
  ClassroomBloc(this.repository) : super(ClassLoading()) {
    on<LoadTeachersClasses>(_loadTeachersClasses);
    on<LoadStudentsClass>(_loadStudentClasses);
  }

  // load classes for a teacher
  Future<void> _loadTeachersClasses(
    LoadTeachersClasses event,
    Emitter<ClassroomState> emit,
  ) async {
    emit(ClassLoading());

    try {
      final classes = repository.fetchClassesForTeacher(event.teacher);
      emit(ClassesLoaded(classes: classes, role: UserRoles.teacher));
    } catch (e) {
      emit(ClassError(message: e.toString()));
    }
  }

  // load class details for a student
  Future<void> _loadStudentClasses(
    LoadStudentsClass event,
    Emitter<ClassroomState> emit,
  ) async {
    emit(ClassLoading());

    try {
      final classes = repository.fetchStudentClassDetails(event.student);
      emit(ClassesLoaded(classes: [classes], role: UserRoles.student));
    } catch (e) {
      emit(ClassError(message: e.toString()));
    }
  }
}
