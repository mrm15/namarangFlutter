import 'package:namarang/core/storage/secure_storage.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request.dart';
import '../models/verify_otp_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  @override
  Future<LoginEntity> sendOtp(LoginRequest request) async {
    final model = await _remoteDataSource.sendOtp(request);

    return model.toEntity();
  }

  @override
  Future<AuthEntity> verifyOtp(VerifyOtpRequest request) async {
    final model = await _remoteDataSource.verifyOtp(request);

    final entity = model.toEntity();

    await _secureStorage.saveTokens(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
    );

    return entity;
  }
}
