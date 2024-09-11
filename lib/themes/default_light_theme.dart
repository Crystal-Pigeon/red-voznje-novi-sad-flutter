import 'package:flutter/material.dart';

const defaultPrimaryColor = Color(0xFF0066CC);
const backgroundColor = Color(0xFFE6E6E6);
const surfaceContainerColor = Color.fromRGBO(255, 255, 255, 1.0);
const onSurfaceColor = Color.fromRGBO(51, 51, 51, 1);
const dividerColor = Color(0xFFE6E6E6);
const textColor = Color(0xFF242429);
const secondaryText = Color(0xFF6E6D6C);

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: defaultPrimaryColor,
    colorScheme: const ColorScheme.light(
      onTertiary: secondaryText,
      onPrimary: defaultPrimaryColor,
      primary: defaultPrimaryColor,
      surface: backgroundColor,
      surfaceContainer: surfaceContainerColor,
      onSurface: onSurfaceColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: ThemeData.light()
        .textTheme
        .copyWith(
          titleLarge: ThemeData.light().textTheme.titleLarge?.copyWith(
                fontSize: 21,
              ),
        )
        .apply(
          bodyColor: textColor,
        ),
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
          backgroundColor: defaultPrimaryColor,
          foregroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 4,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: ThemeData.light()
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 16, color: Colors.white),
        ),
    dividerColor: dividerColor,
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
  );
}
