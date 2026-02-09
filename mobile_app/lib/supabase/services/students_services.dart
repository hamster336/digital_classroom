import 'package:supabase_flutter/supabase_flutter.dart';

class StudentsServices {
  final SupabaseClient client;

  StudentsServices({required this.client});

  // fetch student details from db
  Future<Map<String, dynamic>?> fetchStudentData(String uid) async {
    return await client.from('student').select().eq('id', uid).maybeSingle();
  }
}
