import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lanes_service/lanes_service.dart';
import '../model/lane.dart';
import '../model/selected_lane.dart';

class SelectedLanesNotifier extends StateNotifier<List<SelectedLane>> {
  SelectedLanesNotifier() : super([]) {
    _loadSelectedLanes();
  }

  void toggleLaneSelection(Lane lane, String type) {
    final   SelectedLane? existingLane = state.firstWhereOrNull(
          (selectedLane) => selectedLane.lane.id == lane.id && selectedLane.type == type,
    );

    if (existingLane != null) {
      state = state.where((item) => item != existingLane).toList();
    } else {
      state = [...state, SelectedLane(lane: lane, type: type)];
    }

    _saveSelectedLanes();
  }

  void _loadSelectedLanes() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLanes = prefs.getStringList('selectedLanes') ?? [];
    state = storedLanes.map((json) => SelectedLane.fromJson(jsonDecode(json))).toList();
  }

  void _saveSelectedLanes() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLanes = state.map((selectedLane) => jsonEncode(selectedLane.toJson())).toList();
    prefs.setStringList('selectedLanes', storedLanes);
  }
}

class LanesNotifier extends StateNotifier<Map<String, List<Lane>>> {
  LanesNotifier() : super({});

  Future<void> fetchLanes(BuildContext context, String rv) async {
    if (!state.containsKey(rv)) {
      final lanes = await LanesService().getAllLanes(context, rv);
      state = {...state, rv: lanes};
    }
  }
}
