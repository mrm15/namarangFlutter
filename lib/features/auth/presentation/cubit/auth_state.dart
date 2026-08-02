import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/login_entity.dart';

class AuthState extends Equatable {
  const AuthState({
    this.isLoading = false,
    this.loginResponse,
    this.authResponse,
    this.errorMessage,
  });

  final bool isLoading;

  /// نتیجه ارسال OTP
  final LoginEntity? loginResponse;

  /// نتیجه Verify OTP
  final AuthEntity? authResponse;

  final String? errorMessage;

  AuthState copyWith({
    bool? isLoading,
    LoginEntity? loginResponse,
    AuthEntity? authResponse,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      loginResponse: loginResponse ?? this.loginResponse,
      authResponse: authResponse ?? this.authResponse,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    loginResponse,
    authResponse,
    errorMessage,
  ];
}
