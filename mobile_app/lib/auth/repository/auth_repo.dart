// ignore_for_file: unused_import

import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/user/models/app_user.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

abstract class AuthRepo {
  Future<void> login(String email, String password);

  Future<void> logout();

  Future<void> changePassword(String oldPassword, String newPassword);

  Future<void> requestOTP (String email);

  Future<void> verifyOTP (String email, String otp);

  Future<void> resetPassword (String password);
}
