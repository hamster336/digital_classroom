part of 'reset_password_bloc.dart';

sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}

final class PasswordStateLoading extends ResetPasswordState {}

final class RequestOTPSuccess extends ResetPasswordState {}

final class VerifyOTPSuccess extends ResetPasswordState {}

final class ResetPasswordSuccess extends ResetPasswordState {}

final class RequestOTPFailure extends ResetPasswordState {
  final String message;
  RequestOTPFailure({required this.message});
}

final class VerifyOTPFailure extends ResetPasswordState {
  final String message;
  VerifyOTPFailure({required this.message});
}

final class ResetPasswordFailure extends ResetPasswordState {
  final String message;
  ResetPasswordFailure({required this.message});
}

