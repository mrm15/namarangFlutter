import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

@pragma('vm:entry-point')
class BackgroundService {
  static final service = FlutterBackgroundService();
  static StreamSubscription<Position>? _positionSubscription;

  static Future<void> initialize() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,

        autoStart: false,

        isForegroundMode: true,

        notificationChannelId: 'namrang_location',

        initialNotificationTitle: 'Namrang Tracking',

        initialNotificationContent: 'Location service running',

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

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();

    developer.log('SERVICE STARTED', name: 'NAMRANG');

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();

      service.setForegroundNotificationInfo(
        title: 'Namrang',
        content: 'Tracking driver location',
      );
    }

    final locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,

      distanceFilter: 10,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (position) {
            developer.log(
              'LAT:${position.latitude} '
              'LNG:${position.longitude}',

              name: 'NAMRANG',
            );
          },
        );

    service.on('stop').listen((event) async {
      await _positionSubscription?.cancel();
      _positionSubscription = null;
      service.stopSelf();
    });
  }
}
