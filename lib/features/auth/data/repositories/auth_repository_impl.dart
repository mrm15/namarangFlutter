import 'package:namarang/core/storage/secure_storage.dart';
import 'package:namarang/core/errors/exceptions.dart';
import 'package:namarang/core/errors/failure_mapper.dart';
import 'package:namarang/core/session/session_controller.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request.dart';
import '../models/verify_otp_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
    this._session,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;
  final SessionController _session;

  @override
  Future<LoginEntity> sendOtp(String phoneNumber) async {
    try {
      final model = await _remoteDataSource.sendOtp(
        LoginRequest(phoneNumber: phoneNumber),
      );
      if (!model.success) throw InvalidResponseException(model.message);
      return model.toEntity();
    } catch (error) {
      throw mapException(error);
    }
  }

  @override
  Future<AuthEntity> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final model = await _remoteDataSource.verifyOtp(
        VerifyOtpRequest(phoneNumber: phoneNumber, loginCode: code),
      );
      final entity = model.toEntity();
      if (!entity.success ||
          entity.accessToken.isEmpty ||
          entity.refreshToken.isEmpty) {
        throw InvalidResponseException(entity.message);
      }

      await _secureStorage.saveTokens(
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
      );
      _session.markAuthenticated();
      return entity;
    } catch (error) {
      throw mapException(error);
    }
  }
}
