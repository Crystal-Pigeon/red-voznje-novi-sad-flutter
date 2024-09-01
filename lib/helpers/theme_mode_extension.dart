import 'dart:ui';

import 'package:flutter/material.dart';
import '../themes/default_dark_theme.dart';
import '../themes/default_light_theme.dart';

extension ThemeModeExtension on ThemeMode {
  ThemeData get theme {
    switch (this) {
      case ThemeMode.dark:
        return darkTheme();
      case ThemeMode.light:
        return lightTheme();
      case ThemeMode.system:
        final brightness = PlatformDispatcher.instance.platformBrightness;
        return brightness == Brightness.light ? lightTheme() : darkTheme();
    }
  }
}