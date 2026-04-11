import 'package:bloc/bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo_impl.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final AuthRepoImpl repository;
  PasswordBloc(this.repository) : super(ResetPasswordInitial()) {
    on<RequestOTP>(_requestOTP);
    on<VerifyOTP>(_verifyOTP);
    on<ResetPassword>(_resetPassword);
    on<ChangePassword>(_changePassword);
  }

  // change password
  Future<void> _changePassword(
    ChangePassword event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordStateLoading());

    if (event.newPassword != event.confirmPassword) {
      emit(
        ChangePasswordFailure(message: 'Passwords do not match. Try again :)'),
      );
      return;
    }

    if (event.newPassword.length < 6) {
      emit(
        ChangePasswordFailure(message: 'Password is less than 6 characters.'),
      );
      return;
    }

    try {
      await repository.changePassword(event.oldPassword, event.newPassword);

      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordFailure(message: e.toString()));
    }
  }

  // reset password if forgotten
  Future<void> _resetPassword(
    ResetPassword event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordStateLoading());
    try {
      await repository.resetPassword(event.password);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordFailure(message: e.toString()));
    }
  }

  // request for the otp
  Future<void> _requestOTP(
    RequestOTP event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordStateLoading());
    try {
      await repository.requestOTP(event.email);
      emit(RequestOTPSuccess());
    } catch (e) {
      // log(e.toString());
      emit(RequestOTPFailure(message: e.toString()));
    }
  }

  // verify OTP
  Future<void> _verifyOTP(VerifyOTP event, Emitter<PasswordState> emit) async {
    emit(PasswordStateLoading());
    try {
      await repository.verifyOTP(event.email, event.otp);
      emit(VerifyOTPSuccess());
    } catch (e) {
      emit(VerifyOTPFailure(message: e.toString()));
    }
  }
}
