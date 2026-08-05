import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._loginUseCase, this._verifyOtpUseCase)
    : super(const AuthInitial());

  final LoginUseCase _loginUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  Future<void> sendOtp(String phoneNumber) async {
    if (state.isLoading) return;
    emit(const AuthLoading());

    try {
      final response = await _loginUseCase(phoneNumber);
      emit(OtpSent(response));
    } on Failure catch (failure) {
      emit(AuthFailure(failure.message));
    }
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    if (state.isLoading) return;
    emit(const AuthLoading());

    try {
      final response = await _verifyOtpUseCase(
        phoneNumber: phoneNumber,
        code: code,
      );
      emit(Authenticated(response));
    } on Failure catch (failure) {
      emit(AuthFailure(failure.message));
    }
  }
}
