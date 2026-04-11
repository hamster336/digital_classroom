import 'package:bloc/bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo_impl.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepoImpl repository;
  ResetPasswordBloc(this.repository) : super(ResetPasswordInitial()) {
    on<RequestOTP>(_requestOTP);
    on<VerifyOTP>(_verifyOTP);
    on<ResetPassword>(_resetPassword);
  }

  // reset password if forgotten
  Future<void> _resetPassword(
    ResetPassword event,
    Emitter<ResetPasswordState> emit,
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
    Emitter<ResetPasswordState> emit,
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
  Future<void> _verifyOTP(
    VerifyOTP event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(PasswordStateLoading());
    try {
      await repository.verifyOTP(event.email, event.otp);
      emit(VerifyOTPSuccess());
    } catch (e) {
      emit(VerifyOTPFailure(message: e.toString()));
    }
  }
}
