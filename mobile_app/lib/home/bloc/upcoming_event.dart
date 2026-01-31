part of 'upcoming_bloc.dart';

sealed class UpcomingEvent {}

final class LoadTeachersEvents extends UpcomingEvent {
  final String teacherId;
  String? classId;
  LoadTeachersEvents({required this.teacherId, this.classId});
}

final class LoadStudentsEvents extends UpcomingEvent {
  final String classId;
  LoadStudentsEvents({required this.classId});
}
