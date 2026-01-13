import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/subject/repository/subject_repo.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepo repository;
  SubjectBloc(this.repository) : super(SubjectsLoading()) {
    on<LoadTeachersSubject>(_loadTeachersSubjects);
    on<LoadStudentsSubject>(_loadStudentssSubjects);
  }

  // load subjects of a teacher
  Future<void> _loadTeachersSubjects(LoadTeachersSubject event, Emitter<SubjectState> emit) async{
    emit(SubjectsLoading());

    try{
      final subejcts = repository.teachersSubjects(event.teacher);
      emit(SubjectLoaded(subejcts: subejcts));
    }catch (e){
      emit(SubjectError(message: e.toString()));
    }
  }

  // load subjects of student
  Future<void> _loadStudentssSubjects(LoadStudentsSubject event, Emitter<SubjectState> emit) async{
    emit(SubjectsLoading());

    try{
      final subejcts = repository.studentsSubjects(event.student);
      emit(SubjectLoaded(subejcts: subejcts));
    }catch (e){
      emit(SubjectError(message: e.toString()));
    }
  }
}
