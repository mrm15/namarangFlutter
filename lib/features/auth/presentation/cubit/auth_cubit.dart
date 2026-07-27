import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/login_request.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._loginUseCase) : super(const AuthState());

  final LoginUseCase _loginUseCase;

  Future<void> sendOtp(String phoneNumber) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await _loginUseCase(
        LoginRequest(phoneNumber: phoneNumber),
      );

      emit(state.copyWith(isLoading: false, loginResponse: response));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
