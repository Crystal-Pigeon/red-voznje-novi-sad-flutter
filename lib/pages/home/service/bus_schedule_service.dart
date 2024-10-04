import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import '../../../shared/services/network/base_client.dart';
import '../model/bus_schedule_response.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;


class BusScheduleService extends BaseClient {
  static const String baseUrl = "/red-voznje/ispis-polazaka";

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

  Future<List<BusSchedule>?> getBusSchedule(
      BuildContext context, String laneId, String rv, String day) async {
    final String? datum = await getDate(context);
    if (datum == null) return [];

    final String query = '?rv=$rv&vaziod=$datum&dan=$day&linija%5B%5D=$laneId';
    final response = await get(baseUrl + query, context);

    if (response != null && response is String) {
      try {
        return _parseBusSchedule(response, day);
      } catch (e) {
        debugPrint('Error parsing bus schedule: $e');
        return null;
      }
    }
    return null;
  }

  // Parse HTML response and map it to BusSchedule objects
  List<BusSchedule>? _parseBusSchedule(String htmlResponse, String dayType) {
    final document = parse(htmlResponse);
    final titleElement = document.querySelector('.table-title');
    final tableElement = document.querySelector('table.tabela-polasci');

    if (titleElement == null || tableElement == null) {
      debugPrint('Title or table element not found in HTML.');
      return null; // Incomplete or invalid data
    }

    final lineDetails = titleElement.text.trim();

    // Extract directions (A and B) or single direction
    final directionHeaders = tableElement.querySelectorAll('th');
    final directionCells = tableElement.querySelectorAll('td[valign="top"]');

    if (directionHeaders.isEmpty || directionCells.isEmpty) {
      debugPrint('Direction headers or cells not found.');
      return null;
    }

    // Handling single or two directions
    String? linijaA;
    String? linijaB;
    String? linija;
    Map<String, List<String>>? rasporedA;
    Map<String, List<String>>? rasporedB;
    Map<String, List<String>>? raspored;

    if (directionHeaders.length == 1) {
      // Single direction (linija)
      linija = directionHeaders[0].text.trim();
      raspored = _parseSchedule(directionCells[0].innerHtml);
    } else if (directionHeaders.length >= 2) {
      // Two directions (linijaA and linijaB)
      linijaA = directionHeaders[0].text.trim();
      linijaB = directionHeaders[1].text.trim();
      rasporedA = _parseSchedule(directionCells[0].innerHtml);
      rasporedB = _parseSchedule(directionCells[1].innerHtml);
    }

    return [
      BusSchedule(
        id: lineDetails.split(':')[1].trim(),
        broj: lineDetails.split(' ')[0].trim(),
        naziv: lineDetails,
        linijaA: linijaA,
        linijaB: linijaB,
        linija: linija,
        dan: dayType,
        rasporedA: rasporedA,
        rasporedB: rasporedB,
        raspored: raspored,
      ),
    ];
  }

// Helper function to parse the schedule for direction A, B, or single direction
  Map<String, List<String>> _parseSchedule(String directionHtml) {
    final Map<String, List<String>> schedule = {};

    final document = parse(directionHtml);
    final elements = document.body?.nodes ?? [];

    String? currentHour;
    List<String> currentTimes = [];

    for (var node in elements) {
      if (node is dom.Element && node.localName == 'b') {
        // When a new hour is encountered, store the previous hour's times (if any)
        if (currentHour != null && currentTimes.isNotEmpty) {
          schedule[currentHour] = List<String>.from(currentTimes);
        }

        // Start a new hour
        currentHour = node.text.trim();
        currentTimes = [];
      } else if (node is dom.Element && node.localName == 'sup') {
        // Collect all the times under the current hour
        final timeElements = node.querySelectorAll('span');
        if (timeElements.isNotEmpty) {
          final times = timeElements.map((e) => e.text.trim()).toList();
          currentTimes.addAll(times);  // Add all times to the current hour
        }
      }
    }

    // Don't forget to add the last hour's times to the map
    if (currentHour != null && currentTimes.isNotEmpty) {
      schedule[currentHour] = List<String>.from(currentTimes);
    }

    return schedule;
  }


}
