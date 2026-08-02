import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void d(dynamic message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void i(dynamic message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  static void w(dynamic message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  static void e(dynamic message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static void f(dynamic message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logger.f(message, error: error, stackTrace: stackTrace);
    }
  }
}
