import 'package:supabase_flutter/supabase_flutter.dart';

class NoticeServices {
  final SupabaseClient client;

  NoticeServices({required this.client});

  // fetch notices from db
  Future<List<Map<String, dynamic>>> fetchNotices({
    required int from,
    required int limit,
  }) async {
    final to = from + limit - 1;

    return await client
        .from('notices')
        .select()
        .order('published_at', ascending: false)
        .range(from, to);
  }
}
