import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {
  final SupabaseClient client;

  UserServices({required this.client});

  // fetch user data
  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    return await client.from('users').select().eq('id', uid).maybeSingle();
  }
}
