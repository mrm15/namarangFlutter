import '../entities/work_status.dart';
import '../repositories/work_status_repository.dart';

class SetWorkStatusUseCase {
  const SetWorkStatusUseCase(this._repository);

  final WorkStatusRepository _repository;

  Future<WorkStatus> call(WorkStatus status) {
    return _repository.setWorkStatus(status);
  }
}
