import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/classroom/model/classroom.dart';

import 'package:mobile_app/classroom/repository/classroom_repo_impl.dart';
import 'package:mobile_app/user/models/app_user.dart';

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final ClassroomRepoImpl repository;
  
  ClassroomBloc(this.repository) : super(ClassLoading()) {
    on<LoadClasses>(_loadClassDetails);
  }

  // load class details for a student
  Future<void> _loadClassDetails(
    LoadClasses event,
    Emitter<ClassroomState> emit,
  ) async {
    emit(ClassLoading());

    try {
      final classes = await repository.fetchClasses(event.user);
      emit(ClassesLoaded(classes: classes));
    } catch (e) {
      emit(ClassError(message: e.toString()));
    }
  }
}
