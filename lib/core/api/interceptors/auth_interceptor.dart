import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../storage/secure_storage.dart';
import '../../session/session_controller.dart';
import '../../constants/app_keys.dart';
import '../api_endpoints.dart';

@visibleForTesting
bool shouldSignOutForAuthFailure({
  required String requestPath,
  required int? statusCode,
}) {
  return requestPath == ApiEndpoints.refreshToken && statusCode == 401;
}

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
      options.headers[AppKeys.authorizationHeader] = 'Bearer $accessToken';
    }

    options.headers.addAll({
      AppKeys.clientPlatformHeader: 'flutter',
      AppKeys.appVersionHeader: '1.0.0',
      AppKeys.devicePlatformHeader: defaultTargetPlatform.name,
    });

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final requestPath = err.requestOptions.uri.path;

    // فقط ۴۰۱ خود endpoint رفرش به معنی پایان نشست است. هیچ ۴۰۱ دیگری،
    // خطای ۴۰۳، خطای سرور یا خطای شبکه مستقیماً کاربر را خارج نمی‌کند.
    if (shouldSignOutForAuthFailure(
      requestPath: requestPath,
      statusCode: statusCode,
    )) {
      await _session.signOut();
      return handler.next(err);
    }

    final isUnauthorized = statusCode == 401;
    final alreadyRetried =
        err.requestOptions.extra[AppKeys.retriedRequest] == true;

    if (!isUnauthorized || alreadyRetried) {
      return handler.next(err);
    }

    final refreshToken = await _storage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return handler.next(err);
    }

    try {
      final refreshResponse = await _rawDio.post(
        ApiEndpoints.refreshToken,
        data: {AppKeys.refreshToken: refreshToken},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            AppKeys.clientPlatformHeader: 'flutter',
            AppKeys.appVersionHeader: '1.0.0',
            AppKeys.devicePlatformHeader: defaultTargetPlatform.name,
          },
        ),
      );

      final newData = refreshResponse.data as Map<String, dynamic>;
      final newAccessToken = newData[AppKeys.accessToken] as String;
      final newRefreshToken = newData[AppKeys.refreshToken] as String;

      await _storage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      err.requestOptions.headers[AppKeys.authorizationHeader] =
          'Bearer $newAccessToken';
      err.requestOptions.extra[AppKeys.retriedRequest] = true;

      final retryResponse = await _rawDio.fetch(err.requestOptions);

      return handler.resolve(retryResponse);
    } on DioException catch (refreshError) {
      if (shouldSignOutForAuthFailure(
        requestPath: refreshError.requestOptions.uri.path,
        statusCode: refreshError.response?.statusCode,
      )) {
        await _session.signOut();
      }

      return handler.next(err);
    } catch (_) {
      return handler.next(err);
    }
  }
}
