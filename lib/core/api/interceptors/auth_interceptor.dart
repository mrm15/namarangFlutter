import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({
      'X-Client-Platform': 'flutter',
      'X-App-Version': '1.0.0',
      'X-Device-Platform': defaultTargetPlatform.name,
    });

    return handler.next(options);
  }
}
