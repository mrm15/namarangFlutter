import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

Failure mapException(Object error) {
  if (error is Failure) return error;
  if (error is InvalidResponseException) {
    return ServerFailure(
      error.message.isNotEmpty
          ? error.message
          : 'پاسخ دریافتی از سرور معتبر نیست.',
    );
  }
  if (error is TypeError || error is FormatException) {
    return const InvalidResponseFailure();
  }

  if (error is DioException) {
    if (error.response?.statusCode == 401) return const UnauthorizedFailure();

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NetworkFailure();
    }

    final data = error.response?.data;
    final message = data is Map<String, dynamic> ? data['message'] : null;
    return ServerFailure(
      message is String && message.isNotEmpty
          ? message
          : 'خطایی در ارتباط با سرور رخ داد.',
    );
  }

  return const ServerFailure();
}
