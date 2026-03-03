import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/submission/model/class_students.dart';
import 'package:mobile_app/submission/repository/submission_repo_impl.dart';

part 'submission_event.dart';
part 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final SubmissionRepoImpl repository;

  SubmissionBloc(this.repository) : super(LoadingStudents()) {
    on<LoadStudents>(_loadStudents);
    on<RefreshStudents>(_refreshStudents);
  }

  Map<String, List<ClassStudents>> cached = {};

  // load students related to an assignment
  Future<void> _loadStudents(
    LoadStudents event,
    Emitter<SubmissionState> emit,
  ) async {
    final key = '${event.classId}-${event.subjectId}';

    if (cached.keys.contains(key)) {
      emit(StudentsLoaded(students: cached[key]!));
      return;
    }

    try {
      final students = await repository.getClassStudents(
        event.classId,
        event.subjectId,
      );

      cached[key] = students;

      emit(StudentsLoaded(students: students));
    } catch (e) {
      emit(StudentsLoadingError(message: e.toString()));
    }
  }

  // refresh students
  Future<void> _refreshStudents(
    RefreshStudents event,
    Emitter<SubmissionState> emit,
  ) async {
    final key = '${event.classId}-${event.subjectId}';

    try {
      final students = await repository.getClassStudents(
        event.classId,
        event.subjectId,
      );

      cached[key] = students;

      emit(StudentsLoaded(students: students));
    } catch (e) {
      emit(StudentsLoadingError(message: e.toString()));
    }
  }
}
