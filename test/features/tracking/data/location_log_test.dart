import 'package:flutter_test/flutter_test.dart';
import 'package:namarang/features/tracking/data/models/location_log.dart';

void main() {
  test('API map contains only the location endpoint fields', () {
    final location = LocationLog.fromMap({
      'id': 'point-1',
      'latitude': 35.7,
      'longitude': 51.4,
      'accuracy': 5,
      'altitude': 1200,
      'speed': 10,
      'heading': 90,
      'recordedAt': '2026-08-06T09:50:03.057Z',
      'isMocked': false,
      'syncStatus': 'pending',
      'retryCount': 3,
    });

    expect(location.toApiMap(), {
      'id': 'point-1',
      'latitude': 35.7,
      'longitude': 51.4,
      'accuracy': 5.0,
      'altitude': 1200.0,
      'speed': 10.0,
      'heading': 90.0,
      'recordedAt': '2026-08-06T09:50:03.057Z',
    });
  });
}
