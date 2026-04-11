part of 'password_bloc.dart';

sealed class PasswordState {}

final class ResetPasswordInitial extends PasswordState {}

final class PasswordStateLoading extends PasswordState {}

final class RequestOTPSuccess extends PasswordState {}

final class VerifyOTPSuccess extends PasswordState {}

final class ResetPasswordSuccess extends PasswordState {}

final class RequestOTPFailure extends PasswordState {
  final String message;
  RequestOTPFailure({required this.message});
}

final class VerifyOTPFailure extends PasswordState {
  final String message;
  VerifyOTPFailure({required this.message});
}

final class ResetPasswordFailure extends PasswordState {
  final String message;
  ResetPasswordFailure({required this.message});
}

final class ChangePasswordSuccess extends PasswordState {}

final class ChangePasswordFailure extends PasswordState {
  final String message;
  ChangePasswordFailure({required this.message});
}