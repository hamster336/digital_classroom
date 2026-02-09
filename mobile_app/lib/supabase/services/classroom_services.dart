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
    return await client
        .from('classroom')
        .select()
        .inFilter('id', classIds)
        .eq('is_active', true);
  }
}
