import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:namarang/core/api/api_client.dart';
import 'package:namarang/core/api/dio_client.dart';
import 'package:namarang/core/session/session_controller.dart';
import 'package:namarang/core/storage/secure_storage.dart';
import 'package:namarang/features/tracking/data/datasources/location_log_local_data_source.dart';
import 'package:namarang/features/tracking/data/datasources/location_remote_data_source.dart';
import 'package:namarang/features/tracking/data/models/location_log.dart';
import 'package:namarang/features/tracking/data/services/location_sync_service.dart';

@pragma('vm:entry-point')
class BackgroundService {
  static final service = FlutterBackgroundService();
  static const _trackingInterval = Duration(seconds: 30);
  static Timer? _trackingTimer;
  static bool _isCapturing = false;

  static Future<void> initialize() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,

        autoStart: false,

        autoStartOnBoot: true,

        isForegroundMode: true,

        foregroundServiceTypes: const [AndroidForegroundType.location],

        initialNotificationTitle: 'نمارنگ',

        initialNotificationContent: 'ثبت موقعیت راننده فعال است',

        foregroundServiceNotificationId: 888,
      ),

      iosConfiguration: IosConfiguration(),
    );
  }

  static Future<void> start() async {
    final running = await service.isRunning();

    if (!running) {
      await service.startService();
    }
  }

  static Future<void> stop() async {
    service.invoke('stop');
  }

  static void captureNow() {
    service.invoke('captureNow');
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
    }

    final localDataSource = LocationLogLocalDataSource();
    final secureStorage = SecureStorage();
    final sessionController = SessionController(secureStorage);
    final apiClient = ApiClient(
      DioClient.create(secureStorage, sessionController),
    );
    final syncService = LocationSyncService(
      localDataSource,
      LocationRemoteDataSource(apiClient),
      secureStorage,
    );

    unawaited(_runTrackingCycle(service, localDataSource, syncService));
    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(
      _trackingInterval,
      (_) => unawaited(
        _runTrackingCycle(service, localDataSource, syncService),
      ),
    );

    service.on('captureNow').listen((_) {
      unawaited(_runTrackingCycle(service, localDataSource, syncService));
    });

    service.on('stop').listen((event) async {
      _trackingTimer?.cancel();
      _trackingTimer = null;
      service.stopSelf();
    });
  }

  static Future<void> _runTrackingCycle(
    ServiceInstance service,
    LocationLogLocalDataSource localDataSource,
    LocationSyncService syncService,
  ) async {
    if (_isCapturing) return;
    _isCapturing = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();
      final hasPermission =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;

      if (!serviceEnabled || !hasPermission) {
        developer.log(
          'Location skipped: serviceEnabled=$serviceEnabled, permission=$permission',
          name: 'NamarangTracking',
        );
      } else {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 20),
          ),
        );
        final locationLog = LocationLog.fromPosition(position);
        await localDataSource.save(locationLog);
        final pendingCount = await localDataSource.pendingCount();

        developer.log(
          'Saved offline location: ${locationLog.toMap()}, pendingCount=$pendingCount',
          name: 'NamarangTracking',
        );
      }

      final syncResult = await syncService.syncPending();
      if (syncResult != null) {
        service.invoke('locationSyncResult', syncResult.toEvent());
      }
    } catch (error, stackTrace) {
      developer.log(
        'Failed to capture location',
        name: 'NamarangTracking',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _isCapturing = false;
    }
  }
}
