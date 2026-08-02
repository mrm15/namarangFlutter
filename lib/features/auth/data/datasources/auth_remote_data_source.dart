import 'package:namarang/core/api/api_client.dart';
import 'package:namarang/core/api/api_endpoints.dart';

import '../models/login_request.dart';
import '../models/login_response_model.dart';
import '../models/verify_otp_request.dart';
import '../models/verify_otp_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> sendOtp(LoginRequest request);

  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<LoginResponseModel> sendOtp(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(response.data);
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: request.toJson(),
    );

    return VerifyOtpResponseModel.fromJson(response.data);
  }
}
