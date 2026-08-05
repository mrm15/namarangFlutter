import 'package:flutter/foundation.dart';

import '../storage/secure_storage.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionController extends ChangeNotifier {
  SessionController(this._storage);

  final SecureStorage _storage;
  SessionStatus _status = SessionStatus.unknown;

  SessionStatus get status => _status;

  Future<void> initialize() async {
    try {
      final accessToken = await _storage.getAccessToken();
      final refreshToken = await _storage.getRefreshToken();
      _setStatus(
        accessToken != null &&
                accessToken.isNotEmpty &&
                refreshToken != null &&
                refreshToken.isNotEmpty
            ? SessionStatus.authenticated
            : SessionStatus.unauthenticated,
      );
    } catch (_) {
      _setStatus(SessionStatus.unauthenticated);
    }
  }

  void markAuthenticated() => _setStatus(SessionStatus.authenticated);

  Future<void> signOut() async {
    await _storage.removeTokens();
    _setStatus(SessionStatus.unauthenticated);
  }

  void _setStatus(SessionStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }
}
