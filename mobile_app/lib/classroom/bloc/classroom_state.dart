part of 'classroom_bloc.dart';

sealed class ClassroomState {}

final class ClassLoading extends ClassroomState {}

final class ClassesLoaded extends ClassroomState {
  final List<Classroom> classes;
  final UserRoles role;

  ClassesLoaded({required this.classes, required this.role});
}

final class ClassError extends ClassroomState {
  final String message;
  ClassError({required this.message});
}
