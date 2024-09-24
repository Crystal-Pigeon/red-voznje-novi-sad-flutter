import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization_notifier.dart';

// Define the localization provider
final localizationProvider = StateNotifierProvider<LocalizationNotifier, Locale>(
      (ref) => LocalizationNotifier(),
);
