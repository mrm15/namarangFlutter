import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ProfileModel> getProfile() async {
    final response = await _apiClient.get(ApiEndpoints.userInfo);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid profile response');
    }
    return ProfileModel.fromJson(data);
  }
}
