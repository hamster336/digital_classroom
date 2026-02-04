import 'package:supabase/supabase.dart';

class SubjectServices {
  final SupabaseClient client;

  SubjectServices({required this.client});

  Future<List<Map<String, dynamic>>> fetchSubjects(List<String> ids) async{
    final List<Map< String, dynamic>> list = [];

    for(var id in ids){
      final sub = await client.from('subjects').select().eq('id', id).limit(1).single();

      list.add(sub);
    }

    return list;
  }
}
