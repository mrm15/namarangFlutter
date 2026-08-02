import '../../data/models/login_request.dart';
import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<LoginEntity> call(LoginRequest request) {
    return _repository.sendOtp(request);
  }
}
