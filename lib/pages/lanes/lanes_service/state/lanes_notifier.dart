import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/lanes.dart';

class SelectedLanesNotifier extends StateNotifier<List<Lane>> {
  SelectedLanesNotifier() : super([]) {
    _loadSelectedLanes();
  }

  void toggleLaneSelection(Lane lane) {
    if (state.contains(lane)) {
      state = state.where((item) => item.id != lane.id).toList();
    } else {
      state = [...state, lane];
    }
    _saveSelectedLanes();
  }

  void _loadSelectedLanes() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLanes = prefs.getStringList('selectedLanes') ?? [];
    state = storedLanes.map((json) => Lane.fromJson(jsonDecode(json))).toList();
  }

  void _saveSelectedLanes() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLanes = state.map((lane) => jsonEncode(lane.toJson())).toList();
    prefs.setStringList('selectedLanes', storedLanes);
  }
}