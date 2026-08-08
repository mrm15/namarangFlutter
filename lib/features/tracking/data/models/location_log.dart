import 'package:geolocator/geolocator.dart';

class LocationLog {
  const LocationLog({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    required this.heading,
    required this.recordedAt,
    required this.isMocked,
  });

  factory LocationLog.fromPosition(Position position) {
    final recordedAt = position.timestamp;

    return LocationLog(
      id: '${recordedAt.microsecondsSinceEpoch}_${position.latitude}_${position.longitude}',
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      speed: position.speed,
      heading: position.heading,
      recordedAt: recordedAt,
      isMocked: position.isMocked,
    );
  }

  factory LocationLog.fromMap(Map<String, dynamic> map) {
    return LocationLog(
      id: map['id'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      accuracy: (map['accuracy'] as num).toDouble(),
      altitude: (map['altitude'] as num).toDouble(),
      speed: (map['speed'] as num).toDouble(),
      heading: (map['heading'] as num).toDouble(),
      recordedAt: DateTime.parse(map['recordedAt'] as String),
      isMocked: map['isMocked'] as bool? ?? false,
    );
  }

  final String id;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final double speed;
  final double heading;
  final DateTime recordedAt;
  final bool isMocked;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'heading': heading,
      'recordedAt': recordedAt.toUtc().toIso8601String(),
      'isMocked': isMocked,
      'syncStatus': 'pending',
      'retryCount': 0,
    };
  }

  Map<String, Object> toApiMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'heading': heading,
      'recordedAt': recordedAt.toUtc().toIso8601String(),
    };
  }
}
