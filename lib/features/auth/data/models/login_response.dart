import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final bool success;
  final String message;

  const LoginResponse({required this.success, required this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  @override
  List<Object?> get props => [success, message];
}
