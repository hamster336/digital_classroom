part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthLoading extends AuthState {}

final class Unauthenticated extends AuthState {}

final class Authenticated extends AuthState {
  final AppUser user;
  Authenticated({required this.user});
}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}


// final class PasswordChangeSuccess extends AuthState {}

