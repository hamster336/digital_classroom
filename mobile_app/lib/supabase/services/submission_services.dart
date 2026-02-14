import 'package:supabase_flutter/supabase_flutter.dart';

class SubmissionServices {
  final SupabaseClient client;

  SubmissionServices({required this.client});

  /// FOR STUDENT

  // fetch all submissions for student
  Future<List<Map<String, dynamic>>> fetchSubmissionsForStudent(
    String studentId,
  ) async {
    return await client
        .from('submissions')
        .select()
        .eq('student_id', studentId)
        .order('submitted_at');
  }

  // fetch submission for single assignment
  Future<Map<String, dynamic>?> fetchSingleSubmission(
    String studentId,
    String assignmentId,
  ) async {
    return await client
        .from('submissions')
        .select()
        .eq('student_id', studentId)
        .eq('assignment_id', assignmentId)
        .maybeSingle();
  }

  // submit assignment
  Future<void> addSubmission(Map<String, dynamic> map) async {
    await client.from('submissions').insert(map);
  }

  // resubmit assignment
  Future<void> updateSubmission(Map<String, dynamic> map) async {
    final id = map['id'];
    final data = Map<String, dynamic>.from(map)..remove('id');

    await client.from('submissions').update(data).eq('id', id);
  }



  //? FOR TEACHER

  // fetch submissions of a class
  Future<List<Map<String, dynamic>>> fetchSubmissionForTeacher(
    String assingmentId,
  ) async {
    return await client
        .from('submissions')
        .select()
        .eq('assignment_id', assingmentId)
        .order('submitted_at');
  }
}
