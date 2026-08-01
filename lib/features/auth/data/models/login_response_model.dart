import 'package:namarang/features/auth/domain/entities/login_entity.dart';

class LoginResponseModel {
  const LoginResponseModel({required this.success, required this.message});

  final bool success;
  final String message;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  LoginEntity toEntity() {
    return LoginEntity(success: success, message: message);
  }
}
