import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/subject/repository/subject_repo.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepo repository;
  SubjectBloc(this.repository) : super(SubjectsLoading()) {
    on<LoadSubjects>(_loadSubjects);
  }

  // load subjects
  Future<void> _loadSubjects(
    LoadSubjects event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectsLoading());

    try {
      final subejcts = await repository.fetchSubjects(event.subjectIds);
      emit(SubjectLoaded(subjects: subejcts));
    } catch (e) {
      emit(SubjectError(message: e.toString()));
    }
  }
}
