import 'package:mobile_app/auth/repository/auth_repo.dart';
import 'package:mobile_app/supabase/services/authetication_services.dart';
import 'package:mobile_app/supabase/services/students_services.dart';
import 'package:mobile_app/supabase/services/teachers_services.dart';
import 'package:mobile_app/supabase/services/user_services.dart';
import 'package:mobile_app/user/models/app_user.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthenticationServices authService;
  final UserServices userService;
  final StudentsServices studentService;
  final TeachersServices teacherService;

  AuthRepoImpl({
    required this.authService,
    required this.userService,
    required this.studentService,
    required this.teacherService,
  });

  // login method
  @override
  Future<void> login(String email, String password) async {
    final res = await authService.signIn(email: email, password: password);

    if (res.user == null) {
      throw Exception('Authentication Failed');
    }

    // save the fcm token for the user
    await userService.saveFcmToken();
  }

  // logout method
  @override
  Future<void> logout() async {
    await authService.signOut();
  }

  // get the current user
  Future<AppUser> getCurrentUser() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      throw Exception('No active session');
    }

    final uid = session.user.id;

    final user = await userService.fetchUserData(uid);
    if (user == null) {
      throw Exception('User profile not found');
    }

    final role = user['role'];

    if (role == 'student') {
      final studentData = await studentService.fetchStudentData(uid);
      if (studentData == null) {
        throw Exception('Student profile not found');
      }
      final String? avatarPath = studentData['avatar_path'];
      if (avatarPath == null) {
        studentData['avatar_url'] = null;
      } else {
        studentData['avatar_url'] = userService.fetchURL(avatarPath);
      }
      return Student.fromMap(user, studentData);
    }

    if (role == 'teacher') {
      final teacherData = await teacherService.fetchTeacherData(uid);
      if (teacherData == null) {
        throw Exception('Teacher profile not found');
      }
      final String? avatarPath = teacherData['avatar_path'];
      if (avatarPath == null) {
        teacherData['avatar_url'] = null;
      } else {
        teacherData['avatar_url'] = userService.fetchURL(avatarPath);
      }
      return Teacher.fromMap(user, teacherData);
    }

    throw Exception('Invalid role');
  }

  // change password
  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await authService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // request OTP
  @override
  Future<void> requestOTP(String email) async {
    try {
      await authService.requestOTP(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // verify the OTP
  @override
  Future<void> verifyOTP(String email, String otp) async {
    try {
      await authService.verifyOTP(email, otp);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // reset password
  @override
  Future<void> resetPassword(String password) async {
    try {
      await authService.resetPassword(password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
