import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  const ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Missing profile data');
    }

    final userData = data['userData'];
    if (userData is! Map<String, dynamic>) {
      throw const FormatException('Missing user data');
    }

    String stringValue(String key) => userData[key] as String? ?? '';

    return ProfileModel(
      userId: stringValue('userId'),
      fullName: stringValue('fullName').trim(),
      phoneNumber: stringValue('phoneNumber'),
      email: stringValue('email'),
      departmentName: stringValue('departmentName'),
      roleName: stringValue('roleName'),
      profilePictureUrl: stringValue('profilePictureUrl'),
      province: stringValue('province'),
      city: stringValue('city'),
      address: stringValue('address'),
      contactCode: stringValue('contactCode'),
      userStatus: stringValue('userStatus'),
      workStatus: stringValue('workStatus'),
      isActive: userData['isActive'] as bool? ?? false,
      isDepartmentAdmin: data['isDepartmentAdmin'] as bool? ?? false,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      departmentName: departmentName,
      roleName: roleName,
      profilePictureUrl: profilePictureUrl,
      province: province,
      city: city,
      address: address,
      contactCode: contactCode,
      userStatus: userStatus,
      workStatus: workStatus,
      isActive: isActive,
      isDepartmentAdmin: isDepartmentAdmin,
    );
  }
}
