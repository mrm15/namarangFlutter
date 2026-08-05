import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../domain/entities/work_status.dart';
import '../../domain/repositories/work_status_repository.dart';
import '../datasources/work_status_remote_data_source.dart';

class WorkStatusRepositoryImpl implements WorkStatusRepository {
  const WorkStatusRepositoryImpl(this._remoteDataSource);

  final WorkStatusRemoteDataSource _remoteDataSource;

  @override
  Future<WorkStatus> getWorkStatus() async {
    try {
      final value = await _remoteDataSource.getWorkStatus();
      final status = WorkStatus.fromApi(value);
      if (status == null) throw const InvalidResponseException();
      return status;
    } catch (error) {
      throw mapException(error);
    }
  }

  @override
  Future<WorkStatus> setWorkStatus(WorkStatus status) async {
    try {
      await _remoteDataSource.setWorkStatus(status.apiValue);
      return status;
    } catch (error) {
      throw mapException(error);
    }
  }
}
