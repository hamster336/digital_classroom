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
        .select('class_id')
        .eq('class_id', classId);

    return response.length;
  }
}
