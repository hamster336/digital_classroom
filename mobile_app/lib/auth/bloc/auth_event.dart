part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AppStarted extends AuthEvent {}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

final class LogoutRequested extends AuthEvent {}

final class AuthCheckRequested extends AuthEvent {}
