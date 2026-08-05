import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<LoginEntity> call(String phoneNumber) {
    return _repository.sendOtp(phoneNumber);
  }
}
