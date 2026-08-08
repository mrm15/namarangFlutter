import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (!status.isGranted) {
      return false;
    }

    await Permission.notification.request();

    // Android سرویس مکان را زمانی که اپ جلوی کاربر است شروع می‌کند؛ بنابراین
    // رد کردن دسترسی Always نباید شروع foreground service را متوقف کند.
    await Permission.locationAlways.request();

    return true;
  }
}
