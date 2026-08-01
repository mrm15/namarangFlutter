import 'package:equatable/equatable.dart';

import '../../domain/entities/login_entity.dart';

class AuthState extends Equatable {
  const AuthState({
    this.isLoading = false,
    this.loginResponse,
    this.errorMessage,
  });

  final bool isLoading;
  final LoginEntity? loginResponse;
  final String? errorMessage;

  AuthState copyWith({
    bool? isLoading,
    LoginEntity? loginResponse,
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
