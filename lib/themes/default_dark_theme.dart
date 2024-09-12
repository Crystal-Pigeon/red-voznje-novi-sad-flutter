import 'package:flutter/material.dart';

const defaultPrimaryColor = Color(0xFF0066CC);
const backgroundColor = Color(0xFF242429);
const onBackgroundColor = Color.fromRGBO(142, 142, 147, 1);
const surfaceContainerColor = Color(0xFF2F2F34);
const onSurfaceColor = Colors.white;
const dividerColor = Color(0xFF3A3A3E);
const secondaryText = Color(0xFF828180);

ThemeData darkTheme() {
  return ThemeData(
    fontFamily: 'Manrope',
    brightness: Brightness.dark,
    primaryColor: defaultPrimaryColor,
    colorScheme: const ColorScheme.dark(
      onTertiary: secondaryText,
      onPrimary: defaultPrimaryColor,
      primary: defaultPrimaryColor,
      surface: backgroundColor,
      surfaceContainer: surfaceContainerColor,
      onSurface: onSurfaceColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
          backgroundColor: defaultPrimaryColor,
          foregroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 4,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: ThemeData.dark().textTheme.titleLarge?.copyWith(
              fontSize: 16, color: Colors.white, fontFamily: 'Manrope'),
        ),
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
    )),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      highlightElevation: 1,
    ),
    cardTheme: const CardTheme(
      elevation: 2,
    ),
  );
}
