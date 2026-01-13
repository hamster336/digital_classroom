part of 'classroom_bloc.dart';

sealed class ClassroomEvent {}

final class LoadTeachersClasses extends ClassroomEvent {
  final Teacher teacher;
  LoadTeachersClasses({required this.teacher});
}

final class LoadStudentsClass extends ClassroomEvent {
  final Student student;
  LoadStudentsClass({required this.student});
}
