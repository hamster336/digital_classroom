import 'package:mobile_app/supabase/services/students_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClassroomServices {
  final SupabaseClient client;

  ClassroomServices({required this.client});

  // fetch class for student
  Future<Map<String, dynamic>> fetchStudentClass(String classId) async {
    final map = await client
        .from('classroom')
        .select()
        .eq('id', classId)
        .limit(1)
        .single();

    final studentsService = StudentsServices(client: client);

    map['student_count'] = await studentsService.fetchNumberOfStudents(classId);

    return map;
  }

  // fetch classes for teacher
  Future<List<Map<String, dynamic>>> fetchTeacherClasses(
    List<String> classIds,
  ) async {
    // using rpc function to reduce N queries for student_count for each classrooms
    final response = await client.rpc(
      'get_teacher_classes_with_student_count',
      params: {'class_ids': classIds},
    );

    return List<Map<String, dynamic>>.from(response);
  }
}
