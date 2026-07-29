import 'package:flutter/material.dart';
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

  print('Permission: $position.latitude');
  print('Permission: $position.longitude');

  runApp(const NamrangApp());
}
