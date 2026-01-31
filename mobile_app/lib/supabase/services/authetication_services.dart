import 'package:supabase/supabase.dart';

class AuthenticationServices {
  final SupabaseClient client;

  AuthenticationServices({required this.client});
  // login
  Future<AuthResponse> login({required String email, required String password}) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // logout
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;
}
