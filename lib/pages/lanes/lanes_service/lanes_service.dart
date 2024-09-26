import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../shared/services/network/base_client.dart';
import '../model/lane.dart';
import 'package:html/parser.dart' as html_parser; // Alias the 'html' parser to avoid conflict with Flutter's Element class
import 'package:html/dom.dart' as html_dom;

class LanesService extends BaseClient {
  static String urlAllLanes = "/red-voznje/lista-linija";

  Future<String?> getDate(BuildContext context) async {
    const url = '/feeds/red-voznje';

    final response = await get(url, context);

    if (response != null) {
      try {
        // Trim the string to remove unnecessary whitespace
        final trimmedResponse = response.trim();

        // Parse the trimmed response as JSON
        final List<dynamic> jsonResponse = jsonDecode(trimmedResponse) as List<dynamic>;

        if (jsonResponse.isNotEmpty) {
          final datum = jsonResponse.first['datum'] as String?;
          return datum;
        } else {
          debugPrint('No datum found in response');
          return null;
        }
      } catch (e) {
        debugPrint('Error extracting datum: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<Lane>> getAllLanes(BuildContext context, String rv) async {
    final String? datum = await getDate(context);
    if (datum == null) return [];

    // Fetch data for all days: R (working day), N (night), and S (Saturday)
    final days = ['R', 'N', 'S'];
    List<Lane> allLanes = [];

    for (String day in days) {
      final lanes = await fetchLanesForDay(context, rv, datum, day);
      allLanes.addAll(lanes);
    }

    // Remove duplicates and sort the lanes
    allLanes = _removeDuplicateAndSortLanes(allLanes);

    return allLanes;
  }

  Future<List<Lane>> fetchLanesForDay(BuildContext context, String rv, String datum, String day) async {
    String query = '?rv=$rv&vaziod=$datum&dan=$day';
    final response = await get(urlAllLanes + query, context);

    if (response != null && response is String) {
      return parseLanesFromHtml(response);
    } else {
      return [];
    }
  }

// Function to remove duplicate lanes based on 'id' and sort them
  List<Lane> _removeDuplicateAndSortLanes(List<Lane> lanes) {
    final Map<String, Lane> uniqueLanes = {};

    // Remove duplicates based on 'id'
    for (final lane in lanes) {
      uniqueLanes[lane.id] = lane;
    }

    // Sort lanes
    List<Lane> sortedLanes = uniqueLanes.values.toList();
    sortedLanes.sort((lane1, lane2) => _customLaneSort(lane1, lane2));

    return sortedLanes;
  }

// Custom sorting function to ensure '5N' is placed next to '5'
  int _customLaneSort(Lane lane1, Lane lane2) {
    // Extract base numbers and suffixes
    final RegExp regex = RegExp(r'^(\d+)([A-Za-z]*)$');

    final match1 = regex.firstMatch(lane1.broj);
    final match2 = regex.firstMatch(lane2.broj);

    if (match1 != null && match2 != null) {
      final baseNumber1 = int.parse(match1.group(1)!);
      final baseNumber2 = int.parse(match2.group(1)!);

      // Compare base numbers first
      int comparison = baseNumber1.compareTo(baseNumber2);
      if (comparison != 0) {
        return comparison;
      }

      // If base numbers are equal, compare the suffixes
      final suffix1 = match1.group(2) ?? '';
      final suffix2 = match2.group(2) ?? '';
      return suffix1.compareTo(suffix2);
    }

    // Fallback if no match
    return lane1.broj.compareTo(lane2.broj);
  }


  List<Lane> parseLanesFromHtml(String htmlString) {
    final html_dom.Document document = html_parser.parse(htmlString);
    final List<html_dom.Element> options = document.querySelectorAll('select#linija option');

    return options.map((html_dom.Element option) {
      final value = option.attributes['value'] ?? '';
      final text = option.text;

      final parts = text.split(' ');
      final broj = parts.isNotEmpty ? parts[0] : '';
      final linija = parts.length > 1 ? text.substring(broj.length).trim() : '';

      return Lane(
        id: value,
        broj: broj,
        linija: linija,
      );
    }).toList();
  }
}
