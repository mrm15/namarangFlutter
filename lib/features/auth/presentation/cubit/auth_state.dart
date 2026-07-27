import 'package:equatable/equatable.dart';

import '../../data/models/login_response.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final LoginResponse? loginResponse;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.loginResponse,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    LoginResponse? loginResponse,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      loginResponse: loginResponse ?? this.loginResponse,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, loginResponse, errorMessage];
}
