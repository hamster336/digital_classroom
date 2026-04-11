part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent {}

final class ResetPassword extends ResetPasswordEvent {
  final String password;
  ResetPassword({required this.password});
}

final class RequestOTP extends ResetPasswordEvent {
  final String email;
  RequestOTP({required this.email});
}

final class VerifyOTP extends ResetPasswordEvent {
  final String email;
  final String otp;

  VerifyOTP({required this.email, required this.otp});
}