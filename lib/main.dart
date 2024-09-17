import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_voznje_novi_sad_flutter/helpers/theme_mode_extension.dart';
import 'package:red_voznje_novi_sad_flutter/l10n/l10n.dart';
import 'package:red_voznje_novi_sad_flutter/pages/settings/info_page/state/localization_provider.dart';
import 'config/app_router_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final theme = brightness == Brightness.dark
        ? ThemeMode.dark.theme
        : ThemeMode.light.theme;

    final locale = ref.watch(localizationProvider); // Get locale from the provider

    return MaterialApp.router(
      theme: theme,
      supportedLocales: L10n.all,
      locale: locale, // Use locale from the provider
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Bus NS',
      routerConfig: AppRouterConfig.router,
    );
  }
}
