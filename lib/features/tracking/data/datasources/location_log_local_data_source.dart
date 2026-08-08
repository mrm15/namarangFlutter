import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/location_log.dart';

class LocationLogLocalDataSource {
  static const _boxName = 'pending_location_logs';

  static Future<Box<dynamic>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      final directory = await getApplicationSupportDirectory();
      Hive.init(directory.path);
      return Hive.openBox<dynamic>(_boxName);
    }

    return Hive.box<dynamic>(_boxName);
  }

  Future<void> save(LocationLog location) async {
    final box = await _openBox();
    await box.put(location.id, location.toMap());
  }

  Future<int> pendingCount() async {
    final box = await _openBox();
    return box.length;
  }

  Future<List<Map<String, dynamic>>> getPending({int limit = 5}) async {
    final box = await _openBox();
    final entries = box.toMap().entries.toList()
      ..sort((first, second) {
        final firstMap = Map<String, dynamic>.from(first.value as Map);
        final secondMap = Map<String, dynamic>.from(second.value as Map);
        return (firstMap['recordedAt'] as String).compareTo(
          secondMap['recordedAt'] as String,
        );
      });

    return entries.take(limit).map((entry) {
      return Map<String, dynamic>.from(entry.value as Map);
    }).toList();
  }

  Future<void> remove(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<int> incrementRetryCount(String id) async {
    final box = await _openBox();
    final rawValue = box.get(id);
    if (rawValue is! Map) return 0;

    final value = Map<String, dynamic>.from(rawValue);
    final retryCount = value['retryCount'] as int? ?? 0;
    value['retryCount'] = retryCount + 1;
    await box.put(id, value);
    return retryCount + 1;
  }
}
