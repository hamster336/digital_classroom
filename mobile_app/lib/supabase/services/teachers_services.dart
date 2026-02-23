import 'package:supabase/supabase.dart';

class TeachersServices {
  final SupabaseClient client;

  TeachersServices({required this.client});

  // fetch teacher details from db
  Future<Map<String, dynamic>?> fetchTeacherData(String uid) async {
    return await client.from('teacher').select().eq('id', uid).maybeSingle();
  }

  // update last notice checked time
  Future<void> updateLastNoticeChecked(String id, DateTime time) async {
    await client
        .from('teacher')
        .update({'last_checked_notices': time.toIso8601String()})
        .eq('id', id);
  }
}
