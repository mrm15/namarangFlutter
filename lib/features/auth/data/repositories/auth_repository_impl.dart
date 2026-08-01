import 'package:namarang/features/auth/domain/entities/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<LoginEntity> sendOtp(LoginRequest request) async {
    final model = await _remoteDataSource.sendOtp(request);

    return model.toEntity();
  }
}
