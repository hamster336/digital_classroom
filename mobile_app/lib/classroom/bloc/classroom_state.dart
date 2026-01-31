part of 'classroom_bloc.dart';

sealed class ClassroomState {}

final class ClassLoading extends ClassroomState {}

final class ClassesLoaded extends ClassroomState {
  final List<Classroom> classes;

  ClassesLoaded({required this.classes});
}

final class ClassError extends ClassroomState {
  final String message;
  ClassError({required this.message});
}
