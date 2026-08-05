import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namarang/core/session/session_controller.dart';
import 'package:namarang/core/storage/secure_storage.dart';
import 'package:namarang/core/constants/app_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'requires both access and refresh tokens for an authenticated session',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        AppKeys.accessTokenStorage: 'access',
      });
      final session = SessionController(SecureStorage());

      await session.initialize();

      expect(session.status, SessionStatus.unauthenticated);
    },
  );

  test('recognizes a complete stored session', () async {
    FlutterSecureStorage.setMockInitialValues({
      AppKeys.accessTokenStorage: 'access',
      AppKeys.refreshTokenStorage: 'refresh',
    });
    final session = SessionController(SecureStorage());

    await session.initialize();

    expect(session.status, SessionStatus.authenticated);
  });

  test('sign out removes tokens and updates status', () async {
    FlutterSecureStorage.setMockInitialValues({
      AppKeys.accessTokenStorage: 'access',
      AppKeys.refreshTokenStorage: 'refresh',
    });
    final storage = SecureStorage();
    final session = SessionController(storage);
    await session.initialize();

    await session.signOut();

    expect(session.status, SessionStatus.unauthenticated);
    expect(await storage.getAccessToken(), isNull);
    expect(await storage.getRefreshToken(), isNull);
  });
}
