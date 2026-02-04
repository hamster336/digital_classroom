import 'package:supabase_flutter/supabase_flutter.dart';

class StudentsServices {
  final SupabaseClient client;

  StudentsServices({required this.client});

  // fetch student details from db
  Future<Map<String, dynamic>?> fetchStudentData(String uid) async {
    return await client.from('student').select().eq('id', uid).maybeSingle();
  }

  // fetch subjects
  Future<List<Map<String, dynamic>>> fetchSubjects(
    List<String> subjectIds,
  ) async {
    List<Map<String, dynamic>> list = [];

    for (var id in subjectIds) {
      final sub = await client
          .from('subjects')
          .select()
          .eq('id', id)
          .limit(1)
          .single();

      list.add(sub);
    }
    return list;
  }
}
