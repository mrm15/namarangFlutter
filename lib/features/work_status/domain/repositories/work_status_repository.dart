import '../entities/work_status.dart';

abstract class WorkStatusRepository {
  Future<WorkStatus> getWorkStatus();

  Future<WorkStatus> setWorkStatus(WorkStatus status);
}
