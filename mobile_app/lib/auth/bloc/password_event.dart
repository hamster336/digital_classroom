part of 'password_bloc.dart';

sealed class PasswordEvent {}

final class ResetPassword extends PasswordEvent {
  final String password;
  ResetPassword({required this.password});
}

final class RequestOTP extends PasswordEvent {
  final String email;
  RequestOTP({required this.email});
}

final class VerifyOTP extends PasswordEvent {
  final String email;
  final String otp;

  VerifyOTP({required this.email, required this.otp});
}

final class ChangePassword extends PasswordEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePassword({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}
