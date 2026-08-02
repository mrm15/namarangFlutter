import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
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

  @override
  List<Object?> get props => [
    userId,
    fullName,
    phoneNumber,
    departmentName,
    roleName,
    profilePictureUrl,
    permissions,
  ];
}
