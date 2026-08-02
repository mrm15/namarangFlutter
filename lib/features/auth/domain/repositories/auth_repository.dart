import '../../data/models/login_request.dart';
import '../../data/models/verify_otp_request.dart';
import '../entities/auth_entity.dart';
import '../entities/login_entity.dart';

abstract class AuthRepository {
  Future<LoginEntity> sendOtp(LoginRequest request);

  Future<AuthEntity> verifyOtp(VerifyOtpRequest request);
}
