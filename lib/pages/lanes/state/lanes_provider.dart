import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/lane.dart';
import '../model/selected_lane.dart';
import 'lanes_notifier.dart';

final selectedLanesProvider = StateNotifierProvider<SelectedLanesNotifier, List<SelectedLane>>((ref) {
  return SelectedLanesNotifier();
});


final lanesProvider = StateNotifierProvider<LanesNotifier, Map<String, List<Lane>>>((ref) {
  return LanesNotifier();
});
