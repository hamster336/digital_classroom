import 'package:supabase_flutter/supabase_flutter.dart';

class ClassroomServices {
  final SupabaseClient client;

  ClassroomServices({required this.client});

  // fetch class for student
  Future<Map<String, dynamic>> fetchStudentClass(String classId) async {
    return await client
        .from('classroom')
        .select()
        .eq('id', classId)
        .limit(1)
        .single();
  }

  // fetch classes for teacher
  Future<List<Map<String, dynamic>>> fetchTeacherClasses(
    List<String> classIds,
  ) async {
    List<Map<String, dynamic>> list = [];

    for (var id in classIds) {
      final cls = await client
          .from('classroom')
          .select()
          .eq('id', id)
          .limit(1)
          .single();

      list.add(cls);
    }
    return list;
  }
}
