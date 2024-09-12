import 'package:go_router/go_router.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/home_page.dart';
import 'package:red_voznje_novi_sad_flutter/pages/reorder_list/reorder_lanes_page.dart';
import 'package:red_voznje_novi_sad_flutter/pages/settings/settings_page.dart';
import '../pages/lanes/lanes_page.dart';
import '../pages/settings/info_page/info_page.dart';
import '../pages/splash_screen/splash_screen.dart';

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
    ),
    GoRoute(
      path: '/lanes',
      name: 'lanes',
      builder: (context, GoRouterState state) => const LanesPage(),
    ),
    GoRoute(
      path: '/reorderLanes',
      name: 'reorderLanes',
      builder: (context, GoRouterState state) => const ReorderLanesPage(),
    ),
    GoRoute(
      path: '/info',
      name: 'info',
      builder: (context, GoRouterState state) => const InfoPage(),
    )
  ]);
}
