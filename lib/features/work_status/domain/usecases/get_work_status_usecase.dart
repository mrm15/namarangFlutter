import '../entities/work_status.dart';
import '../repositories/work_status_repository.dart';

class GetWorkStatusUseCase {
  const GetWorkStatusUseCase(this._repository);

  final WorkStatusRepository _repository;

  Future<WorkStatus> call() => _repository.getWorkStatus();
}
