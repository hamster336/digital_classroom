part of 'upcoming_bloc.dart';

sealed class UpcomingEvent {}

final class LoadEvents extends UpcomingEvent {
  final List<String> subjectIds;
  LoadEvents({required this.subjectIds});
}

final class LoadStudentsEvents extends UpcomingEvent {
  final Student student;
  LoadStudentsEvents({required this.student});
}
