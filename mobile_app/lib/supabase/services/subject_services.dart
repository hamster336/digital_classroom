import 'package:supabase/supabase.dart';

class SubjectServices {
  final SupabaseClient client;

  SubjectServices({required this.client});

  // fetch  subjects
  Future<List<Map<String, dynamic>>> fetchSubjects(List<String> ids) async {
    return await client.from('subjects').select().inFilter('id', ids);
  }
}
