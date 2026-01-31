import 'package:supabase/supabase.dart';

class TeachersServices {
  final SupabaseClient client;

  TeachersServices({required this.client});

  // fetch teacher details from db
  Future<Map<String, dynamic>?> fetchTeacherData(String uid) async {
    return await client.from('teacher').select().eq('id', uid).maybeSingle();
  }

  // fetch classes for teacher from db
  Future<List<Map<String, dynamic>>> fetchClasses(List<String> classIds) async {
    List<Map<String, dynamic>> list = [];

    for(var id in classIds){
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
