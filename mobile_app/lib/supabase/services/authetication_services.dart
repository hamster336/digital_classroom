import 'package:supabase/supabase.dart';

class AuthenticationServices {
  final SupabaseClient client;

  AuthenticationServices({required this.client});
  
  // login
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // logout
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final email = client.auth.currentUser?.email;

    if (email == null) {
      throw Exception('Error occured');
    }

    try {
      // reauthenticate user
      final response = await signIn(email: email, password: oldPassword);

      if (response.user == null) {
        throw Exception('Old password is incorrect');
      }

      // Update password
      await client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }
}
