import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (!status.isGranted) {
      return false;
    }

    final background = await Permission.locationAlways.request();

    return background.isGranted;
  }
}
