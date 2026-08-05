import 'package:go_router/go_router.dart';

import '../core/session/session_controller.dart';
import '../core/constants/app_keys.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/otp_page.dart';
import '../features/main/presentation/pages/main_shell_page.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create(SessionController session) {
    return GoRouter(
      initialLocation: session.status == SessionStatus.authenticated
          ? '/home'
          : '/login',
      refreshListenable: session,
      redirect: (context, state) {
        final location = state.matchedLocation;
        final isAuthRoute = location == '/login' || location == '/otp';

        switch (session.status) {
          case SessionStatus.unknown:
            return '/login';
          case SessionStatus.unauthenticated:
            if (!isAuthRoute) return '/login';
            return null;
          case SessionStatus.authenticated:
            return isAuthRoute ? '/home' : null;
        }
      },
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/otp',
          redirect: (context, state) {
            final phone = state.uri.queryParameters[AppKeys.phoneQuery];
            return phone == null || phone.isEmpty ? '/login' : null;
          },
          builder: (context, state) => OtpPage(
            phoneNumber: state.uri.queryParameters[AppKeys.phoneQuery]!,
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainShellPage(),
        ),
      ],
    );
  }
}
