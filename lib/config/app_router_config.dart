import 'package:go_router/go_router.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home_page.dart';
import 'package:red_voznje_novi_sad_flutter/pages/settings_page.dart';
import '../pages/splash_screen.dart';

class AppRouterConfig {
  static final GoRouter router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
      path: '/',
      name: 'splashScreen',
      builder: (context, GoRouterState state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/homePage',
      name: 'homePage',
      builder: (context, GoRouterState state) => const HomePage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, GoRouterState state) => const SettingsPage(),
    )
  ]);
}
