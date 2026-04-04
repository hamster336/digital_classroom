import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleServices {
  final SupabaseClient client;

  ScheduleServices({required this.client});

  // get schedules
  Future<List<Map<String, dynamic>>> getSchedules(String classId) async {
    return client
        .from('schedules')
        .select()
        .eq('class_id', classId)
        .order('created_at');
  }

  // download schedule
  Future<void> downloadSchedule({
    required String name,
    required String filePath,
    required String directory,
    required Function(int recieved, int total) onProgress,
  }) async {
    try {
      final url = client.storage.from('schedules').getPublicUrl(filePath);

      Dio dio = Dio();

      final savePath = '$directory/$name';

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (recieved, total) {
          if (total != -1) {
            onProgress(recieved, total);
          }
        },
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
