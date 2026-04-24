import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo_impl.dart';
import 'package:mobile_app/user/models/app_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepoImpl repository;

  AuthBloc(this.repository) : super(AuthLoading()) {
    on<CheckAuth>(_appStarted);
    on<LoginRequested>(_loginRequested);
    on<LogoutRequested>(_logoutRequested);
    // on<ChangePassword>(_changePassword);
  }

  // starting the application
  Future<void> _appStarted(CheckAuth event, Emitter<AuthState> emit) async {
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
      log(e.toString());
      emit(AuthFailure(message: e.toString()));
    }
  }

  // logout request
  Future<void> _logoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;

    if (currentState is! Authenticated) {
      throw Exception('User not logged in');
    }

    emit(AuthLoading());
    try {
      await repository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
      emit(currentState);
    }
  }
}
