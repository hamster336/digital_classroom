import 'dart:io';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubmissionServices {
  final SupabaseClient client;

  SubmissionServices({required this.client});

  /// FOR STUDENT

  // fetch all submissions for student
  Future<List<Map<String, dynamic>>> fetchSubmissionsForStudent({
    required String classId,
    required String studentId,
  }) async {
    return await client
        .from('app_files')
        .select()
        .eq('class_id', classId)
        .eq('file_context', 'assignment')
        .eq('uploader_id', studentId)
        .order('created_at', ascending: false);
  }

  // submit assignment
  Future<void> addSubmission({
    required File file,
    required String storagePath,
    required Map<String, dynamic> map,
  }) async {
    // first upload the file to bucket
    await client.storage.from('submissions').upload(storagePath, file);

    // add the meta data to the table
    await client.from('app_files').insert(map);
  }

  /// FOR TEACHER

  // fetch submissions of a class
  Future<List<Map<String, dynamic>>> fetchSubmissionForTeacher(
    String classId,
    List<String> assignmentIds,
  ) async {
    return await client
        .from('app_files')
        .select()
        .eq('class_id', classId)
        .eq('file_context', 'assignment')
        .inFilter('owner_id', assignmentIds)
        .order('created_at', ascending: false);
  }

  // downlaod students submitted file
  Future<void> downloadSubmission({
    required String fileName,
    required String filePath,
    required String directory,
  }) async {
    try {
      final url = client.storage
          .from('submissions')
          .getPublicUrl(filePath);

      Dio dio = Dio();

      final savePath = '$directory/$fileName';

      await dio.download(url, savePath);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
