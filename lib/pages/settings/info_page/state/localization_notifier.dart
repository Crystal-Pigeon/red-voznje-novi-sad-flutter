import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationNotifier extends StateNotifier<Locale> {
  LocalizationNotifier() : super(const Locale('sr')) {
    _loadLocale(); // Load locale on initialization
  }

  // Load the saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('locale');

    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  // Set the locale and save it to SharedPreferences
  void setLocale(Locale locale) async {
    state = locale;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  // Reset to the default locale and save it
  void resetLocale() async {
    state = const Locale('sr');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', 'sr');
  }
}
