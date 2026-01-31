part of 'classroom_bloc.dart';

sealed class ClassroomEvent {}

final class LoadClasses extends ClassroomEvent {
  final AppUser user;
  LoadClasses({required this.user});
}
