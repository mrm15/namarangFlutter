import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namarang/core/errors/failures.dart';
import 'package:namarang/core/session/session_controller.dart';
import 'package:namarang/core/storage/secure_storage.dart';
import 'package:namarang/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:namarang/features/auth/data/models/login_request.dart';
import 'package:namarang/features/auth/data/models/login_response_model.dart';
import 'package:namarang/features/auth/data/models/user_model.dart';
import 'package:namarang/features/auth/data/models/verify_otp_request.dart';
import 'package:namarang/features/auth/data/models/verify_otp_response_model.dart';
import 'package:namarang/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'does not persist tokens when OTP verification is unsuccessful',
    () async {
      FlutterSecureStorage.setMockInitialValues({});
      final storage = SecureStorage();
      final session = SessionController(storage);
      final repository = AuthRepositoryImpl(
        _UnsuccessfulAuthDataSource(),
        storage,
        session,
      );

      await expectLater(
        repository.verifyOtp(phoneNumber: '09120000000', code: '0000'),
        throwsA(isA<ServerFailure>()),
      );

      expect(await storage.getAccessToken(), isNull);
      expect(await storage.getRefreshToken(), isNull);
      expect(session.status, SessionStatus.unknown);
    },
  );
}

class _UnsuccessfulAuthDataSource implements AuthRemoteDataSource {
  @override
  Future<LoginResponseModel> sendOtp(LoginRequest request) async {
    return const LoginResponseModel(success: true, message: 'ok');
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequest request) async {
    return const VerifyOtpResponseModel(
      success: false,
      message: 'کد نادرست است.',
      accessToken: '',
      refreshToken: '',
      user: UserModel(
        userId: '',
        fullName: '',
        phoneNumber: '',
        departmentName: '',
        roleName: '',
        profilePictureUrl: '',
        permissions: [],
      ),
    );
  }
}
