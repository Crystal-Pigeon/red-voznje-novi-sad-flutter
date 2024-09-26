import 'package:flutter/material.dart';

const defaultPrimaryColor = Color(0xFF0066CC);
const primaryColor = Color.fromRGBO(255, 255, 255, 1.0);
const secondaryColor = Color(0xFFF5F5F5);
const onSurfaceColor = Color.fromRGBO(51, 51, 51, 1);
const dividerColor = Color(0xFFE6E6E6);
const primaryText = Color(0xFF242429);
const secondaryText = Color(0xFF6E6D6C);

ThemeData lightTheme() {
  return ThemeData(
    fontFamily: 'Manrope',
    brightness: Brightness.light,
    primaryColor: defaultPrimaryColor,
    colorScheme: const ColorScheme.light(
      onTertiary: secondaryText,
      onPrimary: defaultPrimaryColor,
      primary: defaultPrimaryColor,
      surface: secondaryColor,
      surfaceContainer: primaryColor,
      onSurface: onSurfaceColor,
    ),
    scaffoldBackgroundColor: secondaryColor,
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
          backgroundColor: defaultPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: ThemeData.light()
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 16, color: Colors.white),
        ),
    dividerTheme: ThemeData.light().dividerTheme.copyWith(color: dividerColor),
    listTileTheme: ThemeData.light().listTileTheme.copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
    dialogTheme: ThemeData.light().dialogTheme.copyWith(
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(),
          actionsPadding: EdgeInsets.zero,
        ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      backgroundColor: dividerColor,
      shape: const RoundedRectangleBorder(),
    )),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      highlightElevation: 1,
    ),
    cardTheme: const CardTheme(
      elevation: 2,
      shadowColor: Colors.white
    ),
    tabBarTheme: const TabBarTheme(
      dividerColor: Colors.transparent,
    ),
  );
}
