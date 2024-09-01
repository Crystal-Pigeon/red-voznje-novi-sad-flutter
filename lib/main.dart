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

    return MaterialApp.router(
      theme: ThemeMode.system.theme,
      debugShowCheckedModeBanner: false,
      title: 'Bus NS',
      routerConfig: AppRouterConfig.router,
    );
  }
}