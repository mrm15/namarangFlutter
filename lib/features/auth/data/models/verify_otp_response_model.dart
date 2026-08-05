import '../../domain/entities/auth_entity.dart';
import '../../../../core/constants/app_keys.dart';
import 'user_model.dart';

class VerifyOtpResponseModel {
  const VerifyOtpResponseModel({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final userData = data['userInfo'] as Map<String, dynamic>? ?? {};

    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: data[AppKeys.accessToken] ?? '',
      refreshToken: data[AppKeys.refreshToken] ?? '',
      user: UserModel.fromJson(userData),
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      success: success,
      message: message,
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user.toEntity(),
    );
  }
}
