import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {
  final SupabaseClient client;

  UserServices({required this.client});

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    return await client.from('users').select().eq('id', uid).maybeSingle();
  }
  
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
