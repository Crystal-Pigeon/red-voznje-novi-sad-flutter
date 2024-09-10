import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/model/bus_schedule_response.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/service/bus_schedule_service.dart';

final busScheduleProvider = StateNotifierProvider<BusScheduleNotifier, Map<String, List<BusSchedule>>>(
      (ref) => BusScheduleNotifier(),
);

class BusScheduleNotifier extends StateNotifier<Map<String, List<BusSchedule>>> {
  BusScheduleNotifier() : super({});

  Future<void> fetchBusSchedule(BuildContext context, String laneId, String rv) async {
    if (state.containsKey(laneId)) {
      return;
    }

    final busSchedules = await BusScheduleService().getBusSchedule(context, laneId, rv);

    if (busSchedules != null) {
      state = {
        ...state,
        laneId: busSchedules.map((json) => BusSchedule.fromJson(json)).toList(),
      };
    }
  }
}
