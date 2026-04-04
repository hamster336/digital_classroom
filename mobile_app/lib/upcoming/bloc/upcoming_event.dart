part of 'upcoming_bloc.dart';

sealed class UpcomingEvent {}

final class LoadEvents extends UpcomingEvent {
  final List<String> subjectIds;
  LoadEvents({required this.subjectIds});
}

final class RefreshEvents extends UpcomingEvent {
  final List<String> subjectIds;
  RefreshEvents({required this.subjectIds});
}
