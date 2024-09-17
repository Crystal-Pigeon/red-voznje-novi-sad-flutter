import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalizationNotifier extends StateNotifier<Locale> {
  LocalizationNotifier() : super(const Locale('sr'));

  void setLocale(Locale locale) {
    state = locale;
  }

  void resetLocale() {
    state = const Locale('sr');
  }
}
