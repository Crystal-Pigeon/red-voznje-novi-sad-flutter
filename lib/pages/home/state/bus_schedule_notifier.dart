import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/model/bus_schedule_response.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/service/bus_schedule_service.dart';

class BusScheduleState {
  final List<BusSchedule>? schedules;
  final String? error;

  BusScheduleState({this.schedules, this.error});

  factory BusScheduleState.success(List<BusSchedule> schedules) {
    return BusScheduleState(schedules: schedules);
  }

  factory BusScheduleState.failure(String error) {
    return BusScheduleState(error: error);
  }
}

final busScheduleProvider = StateNotifierProvider<BusScheduleNotifier, Map<String, BusScheduleState>>(
      (ref) => BusScheduleNotifier(),
);


class BusScheduleNotifier extends StateNotifier<Map<String, BusScheduleState>> {
  BusScheduleNotifier() : super({});

  Future<void> fetchBusSchedule(BuildContext context, String laneId, String rv) async {
    if (state.containsKey(laneId)) {
      return;
    }

    try {
      final busSchedules = await BusScheduleService().getBusSchedule(context, laneId, rv);

      if (busSchedules != null) {
        state = {
          ...state,
          laneId: BusScheduleState.success(
            busSchedules.map((json) => BusSchedule.fromJson(json)).toList(),
          ),
        };
      } else {
        throw Exception('No schedules found');
      }
    } catch (e) {
      state = {
        ...state,
        laneId: BusScheduleState.failure(e.toString()), // Store the error message
      };
    }
  }
}
