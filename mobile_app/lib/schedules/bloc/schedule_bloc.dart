import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/schedules/model/schedule.dart';
import 'package:mobile_app/schedules/repository/schedules_repo_impl.dart';
import 'package:mobile_app/shared/public_directory.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final SchedulesRepoImpl repository;

  ScheduleBloc(this.repository) : super(ScheduleInitial()) {
    on<LoadSchedules>(_loadSchedules);
    on<RefreshSchedules>(_refreshSchedules);
    on<DownloadSchedule>(_downloadSchedule);
  }

  /// caching loading data
  final Map<String, List<Schedule>> cached = {};

  // refresh schedules
  Future<void> _refreshSchedules(
    RefreshSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    final key = event.classId;

    try {
      final dir = await PublicDirectory.getPublicDirectoryPath();
      final schedules = await repository.getSchedules(event.classId);

      for (var s in schedules) {
        final path = '$dir/${s.name}';
        final exists = await File(path).exists();

        s.isDownloaded = exists;
      }

      cached[key] = schedules;

      emit(SchedulesLoaded(schedules: schedules, downloadProgress: {}));
    } catch (e) {
      emit(ScheduleLoadingError(message: e.toString()));
    }
  }

  // load schedules
  Future<void> _loadSchedules(
    LoadSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    final key = event.classId;

    if (cached.containsKey(key)) {
      emit(SchedulesLoaded(schedules: cached[key]!, downloadProgress: {}));
      return;
    }
    try {
      emit(ScheduleLoading());
      final dir = await PublicDirectory.getPublicDirectoryPath();

      final schedules = await repository.getSchedules(event.classId);

      for (var s in schedules) {
        final path = '$dir/${s.name}';
        final exists = await File(path).exists();

        s.isDownloaded = exists;
      }

      cached[key] = schedules;

      emit(SchedulesLoaded(schedules: schedules, downloadProgress: {}));
    } catch (e) {
      emit(ScheduleLoadingError(message: e.toString()));
    }
  }

  // download schedule
  Future<void> _downloadSchedule(
    DownloadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state is! SchedulesLoaded) return;

    try {
      final currentState = state as SchedulesLoaded;
      final Map<String, double> progressMap = Map<String, double>.from(
        currentState.downloadProgress,
      );

      // start the download
      progressMap[event.schedule.id] = 0;
      double lastProgress = 0;

      emit(currentState.copyWith(downloadProgress: progressMap));

      await repository.downloadSchedule(
        name: event.schedule.name,
        filePath: event.schedule.filePath,
        onProgress: (recieved, total) {
          if (state is! SchedulesLoaded) return;

          final progress = recieved / total;

          if ((progress - lastProgress) > 0.05) {
            lastProgress = progress;

            final latestState = state as SchedulesLoaded;
            final updatedMap = Map<String, double>.from(
              latestState.downloadProgress,
            );

            updatedMap[event.schedule.id] = recieved / total;

            emit(latestState.copyWith(downloadProgress: updatedMap));
          }
        },
      );

      if (state is! SchedulesLoaded) return;

      final latestState = state as SchedulesLoaded;
      final updatedMap = Map<String, double>.from(latestState.downloadProgress);

      updatedMap.remove(event.schedule.id);

      event.schedule.isDownloaded = true;

      emit(latestState.copyWith(downloadProgress: updatedMap));
    } catch (e) {
      if (state is! SchedulesLoaded) return;

      final latestState = state as SchedulesLoaded;
      final updatedMap = Map<String, double>.from(latestState.downloadProgress);

      updatedMap.remove(event.schedule.id);
      emit(DownloadScheduleError(message: e.toString()));
      emit(latestState.copyWith(downloadProgress: updatedMap));
    }
  }
}
