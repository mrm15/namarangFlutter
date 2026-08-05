import '../entities/auth_entity.dart';
import '../entities/login_entity.dart';

abstract class AuthRepository {
  Future<LoginEntity> sendOtp(String phoneNumber);

  Future<AuthEntity> verifyOtp({
    required String phoneNumber,
    required String code,
  });
}
