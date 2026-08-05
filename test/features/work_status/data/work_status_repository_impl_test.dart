import 'package:flutter_test/flutter_test.dart';
import 'package:namarang/core/errors/failures.dart';
import 'package:namarang/features/work_status/data/datasources/work_status_remote_data_source.dart';
import 'package:namarang/features/work_status/data/repositories/work_status_repository_impl.dart';
import 'package:namarang/features/work_status/domain/entities/work_status.dart';

void main() {
  test('maps ready API value to WorkStatus.ready', () async {
    final repository = WorkStatusRepositoryImpl(
      _FakeWorkStatusDataSource(currentStatus: 'ready'),
    );

    expect(await repository.getWorkStatus(), WorkStatus.ready);
  });

  test('sends not_ready API value when status changes', () async {
    final dataSource = _FakeWorkStatusDataSource(currentStatus: 'ready');
    final repository = WorkStatusRepositoryImpl(dataSource);

    final result = await repository.setWorkStatus(WorkStatus.notReady);

    expect(result, WorkStatus.notReady);
    expect(dataSource.lastSetStatus, 'not_ready');
  });

  test('rejects an unknown status returned by API', () async {
    final repository = WorkStatusRepositoryImpl(
      _FakeWorkStatusDataSource(currentStatus: 'unexpected'),
    );

    await expectLater(
      repository.getWorkStatus(),
      throwsA(isA<ServerFailure>()),
    );
  });
}

class _FakeWorkStatusDataSource implements WorkStatusRemoteDataSource {
  _FakeWorkStatusDataSource({required this.currentStatus});

  final String? currentStatus;
  String? lastSetStatus;

  @override
  Future<String?> getWorkStatus() async => currentStatus;

  @override
  Future<void> setWorkStatus(String status) async {
    lastSetStatus = status;
  }
}
