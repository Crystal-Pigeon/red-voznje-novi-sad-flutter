import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../shared/services/network/base_client.dart';
import '../model/lane.dart';
import 'package:html/parser.dart' as html_parser; // Alias the 'html' parser to avoid conflict with Flutter's Element class
import 'package:html/dom.dart' as html_dom;

class LanesService extends BaseClient {
  static String urlAllLanes = "/red-voznje/lista-linija";
  static const String fallbackUrl = 'http://www.gspns.co.rs/red-voznje/gradski';

  Future<String?> getDate(BuildContext context) async {
    const url = '/feeds/red-voznje';

    // Attempt to fetch date from the API endpoint
    final response = await get(url, context);

    if (response != null) {
      if (response.statusCode == 200) {
        try {
          final trimmedResponse = response.body.trim();
          final List<dynamic> jsonResponse = jsonDecode(trimmedResponse) as List<dynamic>;

          if (jsonResponse.isNotEmpty) {
            final datum = jsonResponse.first['datum'] as String?;
            return datum;
          } else {
            debugPrint('No datum found in API response');
            return null;
          }
        } catch (e) {
          debugPrint('Error parsing API JSON response: $e');
          return null;
        }
      } else if (response.statusCode == 404) {
        debugPrint('API returned 404, falling back to HTML page');
        return _fetchDateFromHtml();
      } else {
        debugPrint('API returned unexpected status: ${response.statusCode}');
      }
    } else {
      debugPrint('API response is null, falling back to HTML page');
      return _fetchDateFromHtml();
    }

    return null;
  }

  /// Fetch the date from the fallback HTML page
  Future<String?> _fetchDateFromHtml() async {
    try {
      final fallbackResponse = await http.get(Uri.parse(fallbackUrl));

      if (fallbackResponse.statusCode == 200) {
        final document = html_parser.parse(fallbackResponse.body);

        final selectElement = document.getElementById('vaziod');
        if (selectElement != null) {
          final optionElement = selectElement.getElementsByTagName('option').first;
          if (optionElement != null) {
            final value = optionElement.attributes['value'];
            debugPrint('Extracted value from fallback HTML: $value');
            return value;
          } else {
            debugPrint('No <option> element found under #vaziod');
          }
        } else {
          debugPrint('No element with id "vaziod" found in fallback HTML');
        }
      } else {
        debugPrint('Fallback HTML page returned error: ${fallbackResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching date from fallback HTML: $e');
    }
    return null;
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

    if (response != null) {
      // Check if the response is a raw string
      final String htmlString = response is String ? response : response.body;
      return parseLanesFromHtml(htmlString);
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
