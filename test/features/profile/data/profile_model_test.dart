import 'package:flutter_test/flutter_test.dart';
import 'package:namarang/features/profile/data/models/profile_model.dart';

void main() {
  test('parses the user info response structure', () {
    final model = ProfileModel.fromJson({
      'data': {
        'isDepartmentAdmin': true,
        'userData': {
          'userId': 'user-1',
          'fullName': '  کاربر نمارنگ  ',
          'phoneNumber': '09120000000',
          'email': 'user@example.com',
          'departmentName': 'حمل و نقل',
          'roleName': 'راننده',
          'profilePictureUrl': 'https://example.com/avatar.jpg',
          'province': 'تهران',
          'city': 'تهران',
          'address': 'آدرس نمونه',
          'contactCode': '123',
          'userStatus': 'online',
          'workStatus': 'ready',
          'isActive': true,
        },
      },
    });

    final profile = model.toEntity();

    expect(profile.fullName, 'کاربر نمارنگ');
    expect(profile.profilePictureUrl, 'https://example.com/avatar.jpg');
    expect(profile.location, 'تهران، تهران');
    expect(profile.isDepartmentAdmin, isTrue);
    expect(profile.isActive, isTrue);
  });

  test('rejects a response without userData', () {
    expect(
      () => ProfileModel.fromJson({
        'data': {'isDepartmentAdmin': false},
      }),
      throwsFormatException,
    );
  });
}
