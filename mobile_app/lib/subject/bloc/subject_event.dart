part of 'subject_bloc.dart';

sealed class SubjectEvent {}

final class LoadTeachersSubject extends SubjectEvent {
  final Teacher teacher;
  final String classId;

  LoadTeachersSubject({required this.teacher, required this.classId});
}

final class LoadStudentsSubject extends SubjectEvent {
  final Student student;
  LoadStudentsSubject({required this.student});
}
