import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
// import '../features/home/presentation/pages/home_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(
        path: '/home',
        // builder: (_, __) => const HomePage(),
        builder: (_, __) => const LoginPage(),
      ),
    ],
  );
}
