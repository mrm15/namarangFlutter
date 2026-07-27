import 'package:namarang/core/api/api_client.dart';
import 'package:namarang/core/api/api_endpoints.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> sendOtp(LoginRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<LoginResponse> sendOtp(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    return LoginResponse.fromJson(response.data);
  }
}
