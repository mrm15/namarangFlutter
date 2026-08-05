import 'package:geolocator/geolocator.dart';

class LocationService {
  /// بررسی روشن بودن GPS
  Future<bool> isLocationEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// گرفتن آخرین موقعیت
  Future<Position> getCurrentLocation() async {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );
  }

  /// استریم موقعیت
  Stream<Position> getPositionStream() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,

      // هر ۱۰ متر یک بار
      distanceFilter: 10,
    );

    return Geolocator.getPositionStream(locationSettings: settings);
  }
}
