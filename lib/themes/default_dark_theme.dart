import 'package:flutter/material.dart';

const accentColor = Color(0xFF0066CC);
const defaultPrimaryColor = Color(0xFF28272A);
const backgroundColor = Color.fromRGBO(47, 50, 52, 1.0);
const onBackgroundColor = Color.fromRGBO(142, 142, 147, 1);
const surfaceContainerColor = Color.fromRGBO(64, 67, 68, 1.0);
const onSurfaceColor = Colors.white;
const dividerColor = Color.fromRGBO(142, 142, 147, 1);

ThemeData darkTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: defaultPrimaryColor,
      colorScheme: const ColorScheme.dark(
        onPrimary: accentColor,
        primary: defaultPrimaryColor,
        surface: backgroundColor,
        surfaceContainer: surfaceContainerColor,
        onSurface: onSurfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: ThemeData.dark()
          .textTheme
          .copyWith(
            titleLarge: ThemeData.dark().textTheme.titleLarge?.copyWith(
                  fontSize: 21,
                ),
          )
          .apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
      appBarTheme: ThemeData.dark().appBarTheme.copyWith(
            backgroundColor: defaultPrimaryColor,
            foregroundColor: Colors.white,
            shadowColor: Colors.black,
            elevation: 4,
            surfaceTintColor: Colors.transparent,
            titleTextStyle: ThemeData.dark()
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 16, color: Colors.white),
          ),
      dividerColor: dividerColor,
      dividerTheme: ThemeData.dark().dividerTheme.copyWith(color: dividerColor),
      listTileTheme: ThemeData.dark().listTileTheme.copyWith(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            selectedColor: Colors.white,
          ),
    dialogTheme: ThemeData.dark().dialogTheme.copyWith(
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      actionsPadding: EdgeInsets.zero,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
      )
    ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
      ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor
    )
  );
}
