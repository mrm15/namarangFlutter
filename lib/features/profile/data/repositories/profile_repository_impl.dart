import '../../../../core/errors/failure_mapper.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ProfileEntity> getProfile() async {
    try {
      final model = await _remoteDataSource.getProfile();
      return model.toEntity();
    } catch (error) {
      throw mapException(error);
    }
  }
}
