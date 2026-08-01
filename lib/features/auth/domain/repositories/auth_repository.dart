import '../../data/models/login_request.dart';
import '../entities/login_entity.dart';

abstract class AuthRepository {
  Future<LoginEntity> sendOtp(LoginRequest request);
}
