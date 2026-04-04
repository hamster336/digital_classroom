part of 'schedule_bloc.dart';

sealed class ScheduleEvent {}

final class LoadSchedules extends ScheduleEvent {
  final String classId;
  LoadSchedules({required this.classId});
}

final class RefreshSchedules extends ScheduleEvent {
  final String classId;
  RefreshSchedules({required this.classId});
}

final class DownloadSchedule extends ScheduleEvent {
  final Schedule schedule;
  DownloadSchedule({required this.schedule});
}
