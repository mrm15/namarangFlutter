import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // بعداً Token را اینجا اضافه می‌کنیم

    super.onRequest(options, handler);
  }
}
