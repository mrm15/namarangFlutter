import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_keys.dart';

class SecureStorage {
  SecureStorage();

  static const _storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token) {
    return _storage.write(key: AppKeys.accessTokenStorage, value: token);
  }

  Future<void> saveRefreshToken(String token) {
    return _storage.write(key: AppKeys.refreshTokenStorage, value: token);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: AppKeys.accessTokenStorage);
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: AppKeys.refreshTokenStorage);
  }

  Future<void> removeTokens() async {
    await _storage.delete(key: AppKeys.accessTokenStorage);
    await _storage.delete(key: AppKeys.refreshTokenStorage);
  }

  Future<void> clear() {
    return _storage.deleteAll();
  }
}
