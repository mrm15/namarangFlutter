import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/login_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  bool get isLoading => this is AuthLoading;

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class OtpSent extends AuthState {
  const OtpSent(this.response);

  final LoginEntity response;

  @override
  List<Object?> get props => [response];
}

class Authenticated extends AuthState {
  const Authenticated(this.response);

  final AuthEntity response;

  @override
  List<Object?> get props => [response];
}

class AuthFailure extends AuthState {
  const AuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
