import 'package:supabase_flutter/supabase_flutter.dart';

class StudentsServices {
  final SupabaseClient client;

  StudentsServices({required this.client});

  // fetch student details from db
  Future<Map<String, dynamic>?> fetchStudentData(String uid) async {
    return await client.from('student').select().eq('id', uid).maybeSingle();
  }

  // fetch number of students in a class
  Future<int> fetchNumberOfStudents(String classId) async {
    final response = await client
        .from('student')
        .count()
        .eq('class_id', classId);

    return response;
  }

  // update last notice checked time
  Future<void> updateLastNoticeChecked(String id, DateTime time) async {
    await client
        .from('student')
        .update({'last_checked_notices': time.toIso8601String()})
        .eq('id', id);
  }

  // fetch details of student from a view
  Future<List<Map<String, dynamic>>> fetchStudentsOfClass(
    String classId,
    String subjectId,
  ) async {
    return await client
        .from('class_students')
        .select()
        .eq('class_id', classId)
        .contains('subject_ids', [subjectId])
        .order('roll_number', ascending: true);
  }
}
