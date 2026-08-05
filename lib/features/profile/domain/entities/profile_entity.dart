import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.departmentName,
    required this.roleName,
    required this.profilePictureUrl,
    required this.province,
    required this.city,
    required this.address,
    required this.contactCode,
    required this.userStatus,
    required this.workStatus,
    required this.isActive,
    required this.isDepartmentAdmin,
  });

  final String userId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String departmentName;
  final String roleName;
  final String profilePictureUrl;
  final String province;
  final String city;
  final String address;
  final String contactCode;
  final String userStatus;
  final String workStatus;
  final bool isActive;
  final bool isDepartmentAdmin;

  String get location {
    return [
      province,
      city,
    ].where((value) => value.trim().isNotEmpty).join('، ');
  }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    phoneNumber,
    email,
    departmentName,
    roleName,
    profilePictureUrl,
    province,
    city,
    address,
    contactCode,
    userStatus,
    workStatus,
    isActive,
    isDepartmentAdmin,
  ];
}
