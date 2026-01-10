import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo.dart';
import 'package:mobile_app/user/models/app_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthLoading()) {
    on<AuthCheckRequested>(_authCheckRequested);
    on<LoginRequested>(_loginRequested);
    on<LogoutRequested>(_logoutRequested);
  }

  // check if user is logged in or not
  Future<void> _authCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final AppUser? user = AuthRepo().getUser;

      if (user == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(user: user));
      }
    } catch (ex) {
      emit(AuthFailure(message: 'Failed to Load User'));
    }
  }

  // login request
  FutureOr<void> _loginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) {}

  // logout request
  FutureOr<void> _logoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {}
}
