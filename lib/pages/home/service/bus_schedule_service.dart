import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:red_voznje_novi_sad_flutter/shared/services/network/base_client.dart';
import '../model/bus_schedule_response.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;


class BusScheduleService extends BaseClient {
  static const String baseUrl = "/red-voznje/ispis-polazaka";

  Future<List<BusSchedule>?> getBusSchedule(
      BuildContext context, String laneId, String rv, String day) async {
    final String query = '?rv=$rv&vaziod=2024-09-09&dan=$day&linija%5B%5D=$laneId';
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

    // Extract directions (A and B)
    final directionHeaders = tableElement.querySelectorAll('th');
    if (directionHeaders.length < 2) {
      debugPrint('Direction headers not found.');
      return null;
    }

    final directionAHeader = directionHeaders[0].text.trim();
    final directionBHeader = directionHeaders[1].text.trim();

    // Extract schedule data for directions A and B
    final directionCells = tableElement.querySelectorAll('td[valign="top"]');
    if (directionCells.length < 2) {
      debugPrint('Direction cells not found.');
      return null;
    }

    final directionAHtml = directionCells[0].innerHtml;
    final directionBHtml = directionCells[1].innerHtml;

    final parsedA = _parseSchedule(directionAHtml);
    final parsedB = _parseSchedule(directionBHtml);

    return [
      BusSchedule(
        id: lineDetails.split(':')[1].trim(),
        broj: lineDetails.split(' ')[0].trim(),
        naziv: lineDetails,
        dan: dayType,
        linijaA: directionAHeader,
        linijaB: directionBHeader,
        rasporedA: parsedA,
        rasporedB: parsedB,
      ),
    ];
  }

// Helper function to parse the schedule for direction A or B
  Map<String, List<String>> _parseSchedule(String directionHtml) {
    final Map<String, List<String>> schedule = {};

    final document = parse(directionHtml);
    final elements = document.body?.nodes ?? [];

    String? currentHour;
    for (var node in elements) {
      if (node is dom.Element && node.localName == 'b') {
        currentHour = node.text.trim();
      } else if (node is dom.Element && node.localName == 'sup') {
        final timeElements = node.querySelectorAll('span');
        if (currentHour != null && timeElements.isNotEmpty) {
          final times = timeElements.map((e) => e.text.trim()).toList();
          schedule[currentHour] = times;
        }
      }
    }

    return schedule;
  }

}
