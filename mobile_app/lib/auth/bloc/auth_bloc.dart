import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo_impl.dart';
import 'package:mobile_app/user/models/app_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepoImpl repository;

  AuthBloc(this.repository) : super(AuthLoading()) {
    on<AppStarted>(_appStarted);
    on<LoginRequested>(_loginRequested);
    on<LogoutRequested>(_logoutRequested);
    on<ChangePassword>(_changePassword);
  }

  // starting the application
  Future<void> _appStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final user = await repository.getCurrentUser();
      emit(Authenticated(user: user));
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  // login request
  Future<void> _loginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.login(event.email, event.password);
      final user = await repository.getCurrentUser();
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  // logout request
  Future<void> _logoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _changePassword(
    ChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    if (event.newPassword != event.confirmPassword) {
      emit(AuthFailure(message: 'Passwords do not match. Try again :)'));
      return;
    }
    final currentState = state;

    if (currentState is! Authenticated) {
      throw Exception('User not logged in');
    }

    try {
      await repository.changePassword(event.oldPassword, event.newPassword);

      emit(PasswordChangeSuccess());
      
      emit(Authenticated(user: currentState.user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
      emit(currentState);
    }
  }
}
