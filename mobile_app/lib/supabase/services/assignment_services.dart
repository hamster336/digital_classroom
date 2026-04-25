import 'package:supabase_flutter/supabase_flutter.dart';

class AssignmentServices {
  final SupabaseClient client;

  AssignmentServices({required this.client});

  // load assignments for teacher
  Future<List<Map<String, dynamic>>> fetchTeachersAssignments(
    String teacherId,
    String classId,
  ) async {
    return await client
        .from('assignments')
        .select()
        .eq('class_id', classId)
        .eq('teacher_id', teacherId)
        .order('issued_at');
  }

  // fetch number of active assignments across all classes for a teacher
  Future<int> fetchActiveAssignmentCount(String teacherId) async {
    return await client
        .from('assignments')
        .count()
        .eq('teacher_id', teacherId)
        .gt('due_date', DateTime.now().toUtc().toIso8601String());
  }

  // load assignments for teacher
  Future<List<Map<String, dynamic>>> fetchStudentsAssignments(
    String classId,
    List<String> subjectIds,
  ) async {
    return client
        .from('assignments')
        .select()
        .eq('class_id', classId)
        .inFilter('subject_id', subjectIds)
        .order('issued_at');
  }

  // add new assignment
  Future<void> addAssignment(Map<String, dynamic> map) async {
    await client.from('assignments').insert(map);
  }

  // update assignment
  Future<void> updateAssignment(Map<String, dynamic> map) async {
    final id = map['id'];
    final data = Map<String, dynamic>.from(map)..remove('id');

    await client.from('assignments').update(data).eq('id', id);
  }

  // delete assignment
  Future<void> deleteAssignment(String id) async {
    await client.from('assignments').delete().eq('id', id);
  }
}