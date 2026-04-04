import 'package:mobile_app/schedules/model/schedule.dart';
import 'package:mobile_app/schedules/repository/schedules_repo.dart';
import 'package:mobile_app/shared/public_directory.dart';
import 'package:mobile_app/supabase/services/schedule_services.dart';

class SchedulesRepoImpl extends SchedulesRepo {
  final ScheduleServices services;

  SchedulesRepoImpl({required this.services});

  @override
  Future<List<Schedule>> getSchedules(String classId) async {
    try {
      final list = await services.getSchedules(classId);

      return list.map((s) => Schedule.fromMap(s)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> downloadSchedule({
    required String name,
    required String filePath,
    required Function(int recieved, int total) onProgress,
  }) async {
    try {
      final directory = await PublicDirectory.getPublicDirectoryPath();
      await services.downloadSchedule(
        name: name,
        filePath: filePath,
        directory: directory!,
        onProgress: onProgress,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
