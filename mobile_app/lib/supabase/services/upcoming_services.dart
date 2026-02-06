import 'package:supabase_flutter/supabase_flutter.dart';

class UpcomingServices {
  final SupabaseClient client;

  UpcomingServices({required this.client});

  // load nearest 3 assignments
  Future<List<Map<String, dynamic>>> fetchUpcomingAssignments(List<String> subjectIds) async {
    return await client
        .from('assignments')
        .select()
        .inFilter('subject_id', subjectIds)
        .gte('due_date', DateTime.now().toIso8601String())
        .order('due_date', ascending: true)
        .limit(3);
  }

  // fetch nearest 3 scheduled notices
  Future<List<Map<String, dynamic>>> fetchUpcomingNotices() async {
    return await client
        .from('notices')
        .select()
        .not('scheduled_at', 'is', null)
        .gte('scheduled_at',  DateTime.now().toIso8601String())
        .order('scheduled_at', ascending: true)
        .limit(3);
  }
}
