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
    final days = ['R', 'S', 'N']; // R: Workday, S: Saturday, N: Sunday

    for (final day in days) {
      try {
        final busSchedules = await BusScheduleService().getBusSchedule(context, laneId, rv, day);
        if (busSchedules != null) {
          state = {
            ...state,
            '$laneId-$day': BusScheduleState.success(busSchedules),
          };
        } else {
          throw Exception('No schedules found for day $day');
        }
      } catch (e) {
        state = {
          ...state,
          '$laneId-$day': BusScheduleState.failure(e.toString()),
        };
      }
    }
  }

  void clearSchedules() {
    state = {};
  }
}
