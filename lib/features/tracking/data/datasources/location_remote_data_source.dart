import 'package:dio/dio.dart';
import 'package:namarang/core/api/api_client.dart';
import 'package:namarang/core/api/api_endpoints.dart';

class LocationRemoteDataSource {
  const LocationRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Response<dynamic>> send(Map<String, dynamic> location) {
    return _apiClient.post(ApiEndpoints.sendLocation, data: location);
  }
}
