import 'package:go_router/go_router.dart';

import '../features/auth/view/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  );
}