import '../../data/models/verify_otp_request.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthEntity> call(VerifyOtpRequest request) {
    return _repository.verifyOtp(request);
  }
}
