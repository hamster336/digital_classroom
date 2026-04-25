import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserServices {
  final SupabaseClient client;

  UserServices({required this.client});

  // fetch user data
  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    return await client.from('users').select().eq('id', uid).maybeSingle();
  }

  // get user avatar url
  String fetchURL(String avatarPath) {
    return client.storage.from('avatars').getPublicUrl(avatarPath);
  }

  // save fcm tokens
  Future<void> saveFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    final userId = Supabase.instance.client.auth.currentUser!.id;

    await Supabase.instance.client.from('user_tokens').upsert({
      'user_id': userId,
      'fcm_token': token,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
