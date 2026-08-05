import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../storage/secure_storage.dart';
import '../../session/session_controller.dart';
import '../api_endpoints.dart';

/// اینترسپتور احراز هویت.
///
/// وظایف:
///  ۱. accessToken رو روی هر ریکوئست خروجی می‌ذاره.
///  ۲. اگر سرور ۴۰۱ برگردونه (accessToken منقضی شده)، با refreshToken یک
///     accessToken جدید می‌گیره، توکن‌های جدید رو ذخیره می‌کنه، و ریکوئست
///     اصلی رو دوباره می‌فرسته — کاملاً شفاف برای لایه‌های بالاتر
///     (Cubit / UseCase / Repository).
///
/// نکته: endpoint رفرش (`/refresh`) با `application/x-www-form-urlencoded`
/// کار می‌کنه، نه JSON.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._storage, this._session);

  final SecureStorage _storage;
  final SessionController _session;

  /// یک Dio خام و بدون هیچ interceptor ای، مخصوص زدن /refresh و retry
  /// کردن ریکوئست اصلی. چون هیچ اینترسپتوری روش نیست، هیچ‌وقت خودش وارد
  /// چرخه‌ی ۴۰۱/رفرش نمی‌شود؛ در نتیجه حلقه‌ی بی‌نهایت رخ نمی‌دهد.
  final Dio _rawDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _storage.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    options.headers.addAll({
      'X-Client-Platform': 'flutter',
      'X-App-Version': '1.0.0',
      'X-Device-Platform': defaultTargetPlatform.name,
    });

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (!isUnauthorized || alreadyRetried) {
      return handler.next(err);
    }

    final refreshToken = await _storage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await _session.signOut();
      return handler.next(err);
    }

    try {
      final refreshResponse = await _rawDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'x-client-platform': 'flutter',
            'x-app-version': '1.0.0',
            'x-device-platform': defaultTargetPlatform.name,
          },
        ),
      );

      final newData = refreshResponse.data as Map<String, dynamic>;
      final newAccessToken = newData['accessToken'] as String;
      final newRefreshToken = newData['refreshToken'] as String;

      await _storage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      err.requestOptions.extra['retried'] = true;

      final retryResponse = await _rawDio.fetch(err.requestOptions);

      return handler.resolve(retryResponse);
    } catch (_) {
      await _session.signOut();
      return handler.next(err);
    }
  }
}
