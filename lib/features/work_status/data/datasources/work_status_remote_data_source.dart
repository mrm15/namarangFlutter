import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/constants/app_keys.dart';

abstract class WorkStatusRemoteDataSource {
  Future<String?> getWorkStatus();

  Future<void> setWorkStatus(String status);
}

class WorkStatusRemoteDataSourceImpl implements WorkStatusRemoteDataSource {
  const WorkStatusRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<String?> getWorkStatus() async {
    final response = await _apiClient.get(ApiEndpoints.getWorkStatus);
    final data = response.data;
    return data is Map<String, dynamic>
        ? data[AppKeys.workStatus] as String?
        : null;
  }

  @override
  Future<void> setWorkStatus(String status) async {
    await _apiClient.post(
      ApiEndpoints.setWorkStatus,
      data: {AppKeys.workStatus: status},
    );
  }
}
