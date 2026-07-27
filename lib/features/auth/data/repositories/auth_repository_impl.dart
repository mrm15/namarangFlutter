import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<LoginResponse> sendOtp(LoginRequest request) {
    return _remoteDataSource.sendOtp(request);
  }
}
