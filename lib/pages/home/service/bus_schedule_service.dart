import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../shared/services/network/base_client.dart';

class BusScheduleService extends BaseClient {
  static const String urlAllBuses = "/all-buses/";

  Future<List<Map<String, dynamic>>?> getBusSchedule(BuildContext context, String laneId, String rv) async {
    String query = '$laneId?rv=$rv';
    final response = await get(urlAllBuses + query, context);

    if (response != null) {
      try {
        if (response is String) {
          return List<Map<String, dynamic>>.from(jsonDecode(response));
        } else if (response is List) {
          return List<Map<String, dynamic>>.from(response);
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        debugPrint('Error parsing bus schedule: $e');
        return null;
      }
    } else {
      return null;
    }
  }
}
