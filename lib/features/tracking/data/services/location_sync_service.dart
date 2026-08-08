import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:namarang/core/storage/secure_storage.dart';

import '../datasources/location_log_local_data_source.dart';
import '../datasources/location_remote_data_source.dart';
import '../models/location_log.dart';

class LocationSyncResult {
  const LocationSyncResult({
    required this.success,
    required this.message,
    this.statusCode,
    this.response,
  });

  final bool success;
  final String message;
  final int? statusCode;
  final String? response;

  Map<String, dynamic> toEvent() {
    return {
      'success': success,
      'message': message,
      'statusCode': statusCode,
      'response': response,
    };
  }
}

class LocationSyncService {
  const LocationSyncService(
    this._localDataSource,
    this._remoteDataSource,
    this._secureStorage,
  );

  final LocationLogLocalDataSource _localDataSource;
  final LocationRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  Future<LocationSyncResult?> syncPending() async {
    final accessToken = await _secureStorage.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      developer.log(
        'Location sync skipped: no authenticated session',
        name: 'NamarangTracking',
      );
      return const LocationSyncResult(
        success: false,
        message: 'کاربر وارد حساب نشده است.',
      );
    }

    final pendingLocations = await _localDataSource.getPending();
    LocationSyncResult? lastResult;

    for (var index = 0; index < pendingLocations.length; index++) {
      final location = pendingLocations[index];
      final id = location['id'] as String;
      final apiData = LocationLog.fromMap(location).toApiMap();

      try {
        final response = await _remoteDataSource.send(apiData);
        await _localDataSource.remove(id);
        lastResult = LocationSyncResult(
          success: true,
          message: 'موقعیت با موفقیت ارسال شد.',
          statusCode: response.statusCode,
          response: response.data?.toString(),
        );
        developer.log('Location synced: id=$id', name: 'NamarangTracking');

        if (index < pendingLocations.length - 1) {
          await Future<void>.delayed(const Duration(seconds: 1));
        }
      } on DioException catch (error, stackTrace) {
        final retryCount = await _localDataSource.incrementRetryCount(id);
        final statusCode = error.response?.statusCode;
        final responseBody = error.response?.data?.toString();
        lastResult = LocationSyncResult(
          success: false,
          message: 'ارسال انجام نشد و موقعیت آفلاین باقی ماند.',
          statusCode: statusCode,
          response: responseBody ?? error.message ?? error.type.name,
        );
        developer.log(
          'Location sync failed; kept offline: '
          'id=$id, statusCode=$statusCode, retryCount=$retryCount, '
          'response=$responseBody, request=$apiData',
          name: 'NamarangTracking',
          error: error,
          stackTrace: stackTrace,
        );

        // اگر اولین رکورد ارسال نشد، ادامه صف نیز احتمالاً به همان دلیل
        // شکست می‌خورد؛ در چرخه ۳۰ ثانیه‌ای بعد دوباره تلاش می‌کنیم.
        break;
      } catch (error, stackTrace) {
        final retryCount = await _localDataSource.incrementRetryCount(id);
        lastResult = LocationSyncResult(
          success: false,
          message: 'خطای داخلی هنگام آماده‌سازی موقعیت رخ داد.',
          response: error.toString(),
        );
        developer.log(
          'Unexpected location sync failure: '
          'id=$id, retryCount=$retryCount, request=$apiData',
          name: 'NamarangTracking',
          error: error,
          stackTrace: stackTrace,
        );
        break;
      }
    }

    return lastResult;
  }
}
