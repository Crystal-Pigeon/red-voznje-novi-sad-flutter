import 'dart:convert';
import 'package:flutter/material.dart';
import '../../splash_screen/shared/services/network/base_client.dart';
import '../model/lane.dart';

class LanesService extends BaseClient {
  static String urlAllLanes = "/all-lanes";

  Future<List<Lane>> getAllLanes(BuildContext context, String rv) async {
    String query = '?rv=$rv';
    final response = await get(urlAllLanes + query, context);

    if (response != null) {
      try {
        // If the response is a JSON string, decode it; if it's already a list, use it directly.
        if (response is String) {
          List jsonList = jsonDecode(response) as List;
          return jsonList.map((json) => Lane.fromJson(json as Map<String, dynamic>)).toList();
        } else if (response is List) {
          // If the response is already a List
          return response.map((json) => Lane.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        debugPrint('Error parsing lanes: $e');
        return [];
      }
    } else {
      return [];
    }
  }
}
