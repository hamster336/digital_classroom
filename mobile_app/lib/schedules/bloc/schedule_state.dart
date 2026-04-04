part of 'schedule_bloc.dart';

sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleLoading extends ScheduleState {}

final class SchedulesLoaded extends ScheduleState {
  final List<Schedule> schedules;
  final Map<String, double> downloadProgress;

  SchedulesLoaded({required this.schedules, required this.downloadProgress});

  SchedulesLoaded copyWith({
    List<Schedule>? schedules,
    Map<String, double>? downloadProgress,
  }) {
    return SchedulesLoaded(
      schedules: schedules ?? this.schedules,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}

final class ScheduleLoadingError extends ScheduleState {
  final String message;
  ScheduleLoadingError({required this.message});
}

final class DownloadScheduleSuccess extends ScheduleState {}

final class DownloadScheduleError extends ScheduleState {
  final String message;
  DownloadScheduleError({required this.message});
}
