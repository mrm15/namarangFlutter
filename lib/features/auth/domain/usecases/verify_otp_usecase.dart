import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthEntity> call({required String phoneNumber, required String code}) {
    return _repository.verifyOtp(phoneNumber: phoneNumber, code: code);
  }
}
