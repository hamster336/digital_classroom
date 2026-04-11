part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class CheckAuth extends AuthEvent {}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

// final class ChangePassword extends AuthEvent {
//   final String oldPassword;
//   final String newPassword;
//   final String confirmPassword;

//   ChangePassword({
//     required this.oldPassword,
//     required this.newPassword,
//     required this.confirmPassword,
//   });
// }

final class LogoutRequested extends AuthEvent {}

