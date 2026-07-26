import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // بعداً مدیریت خطاها

    super.onError(err, handler);
  }
}
