import 'package:mobile_app/schedules/model/schedule.dart';

abstract class SchedulesRepo {
  Future<List<Schedule>> getSchedules(String classId);

  Future<void> downloadSchedule({
    required String name,
    required String filePath,
    required Function(int recieved, int total) onProgress,
  });
}
