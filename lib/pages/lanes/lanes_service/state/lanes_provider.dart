import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../model/lanes.dart';
import 'lanes_notifier.dart';

final selectedLanesProvider = StateNotifierProvider<SelectedLanesNotifier, List<Lane>>((ref) {
  return SelectedLanesNotifier();
});