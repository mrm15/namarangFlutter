import '../../domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.departmentName,
    required this.roleName,
    required this.profilePictureUrl,
    required this.permissions,
  });

  final String userId;
  final String fullName;
  final String phoneNumber;
  final String departmentName;
  final String roleName;
  final String profilePictureUrl;
  final List<String> permissions;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['userData'] as Map<String, dynamic>? ?? {};

    return UserModel(
      userId: userData['userId'] ?? '',
      fullName: userData['fullName'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      departmentName: userData['departmentName'] ?? '',
      roleName: userData['roleName'] ?? '',
      profilePictureUrl: userData['profilePictureUrl'] ?? '',
      permissions: List<String>.from(json['roleAccessList'] ?? const []),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      departmentName: departmentName,
      roleName: roleName,
      profilePictureUrl: profilePictureUrl,
      permissions: permissions,
    );
  }
}
