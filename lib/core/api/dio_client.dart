import 'package:dio/dio.dart';
import 'package:namarang/core/api/interceptors/auth_interceptor.dart';
import 'package:namarang/core/api/interceptors/error_interceptor.dart';
import 'package:namarang/core/api/interceptors/logger_interceptor.dart';
import 'package:namarang/core/storage/secure_storage.dart';
import 'package:namarang/core/session/session_controller.dart';

import 'api_endpoints.dart';

class DioClient {
  DioClient._();

  static Dio create(SecureStorage storage, SessionController session) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(storage, session),

      ErrorInterceptor(),

      loggerInterceptor(),
    ]);

    return dio;
  }
}
