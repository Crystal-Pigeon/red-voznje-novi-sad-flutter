import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_voznje_novi_sad_flutter/helpers/theme_mode_extension.dart';
import 'config/app_router_config.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    final ThemeData theme = brightness == Brightness.dark
        ? ThemeMode.dark.theme
        : ThemeMode.light.theme;

    return MaterialApp.router(
      theme: theme,
      debugShowCheckedModeBanner: false,
      title: 'Bus NS',
      routerConfig: AppRouterConfig.router,
    );
  }
}
