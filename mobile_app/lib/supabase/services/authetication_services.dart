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

  // request otp
  Future<void> requestOTP(String email) async {
    await client.auth.signInWithOtp(
      email: email,
      shouldCreateUser: false,
      emailRedirectTo: null,
      data: {},
    );
  }

  // verify otp
  Future<void> verifyOTP(String email, String otp) async {
    await client.auth.verifyOTP(email: email, token: otp, type: OtpType.email);
  }

  // reset password
  Future<void> resetPassword(String password) async {
    await client.auth.updateUser(UserAttributes(password: password));
  }
}
