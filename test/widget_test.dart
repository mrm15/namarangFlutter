import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namarang/app/app.dart';
import 'package:namarang/app/router.dart';
import 'package:namarang/core/di/locator.dart';
import 'package:namarang/core/session/session_controller.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await locator.reset();
    await setupLocator();
  });

  tearDown(() => locator.reset());

  testWidgets('unauthenticated user is redirected to login', (tester) async {
    final session = locator<SessionController>();
    final router = AppRouter.create(session);

    await tester.pumpWidget(NamrangApp(router: router));
    await tester.pumpAndSettle();

    expect(find.text('به نمارنگ خوش اومدی 👋'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/login');

    router.dispose();
  });
}
