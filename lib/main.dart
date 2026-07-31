import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:namarang/core/services/background_service.dart';
import 'package:namarang/core/services/location_service.dart';
import 'package:namarang/core/services/permission_service.dart';

import 'app/app.dart';
import 'core/di/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  final permission = PermissionService();

  final granted = await permission.requestLocationPermission();

  print('Permission: $granted');
  final location = LocationService();

  final position = await location.getCurrentLocation();
  await BackgroundService.initialize();
  await BackgroundService.start();
  final isRunning = await FlutterBackgroundService().isRunning();

  debugPrint('Service running: $isRunning');

  print('Permission: $position.latitude');
  final subscription = location.getPositionStream().listen((position) {
    debugPrint('MAIN => ${position.latitude}, ${position.longitude}');
  });
  runApp(const NamrangApp());
}
