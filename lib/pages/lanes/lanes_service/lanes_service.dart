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

    String query = '?rv=$rv&vaziod=$datum&dan=R';
    final response = await get(urlAllLanes + query, context);

    if (response != null && response is String) {
      return parseLanesFromHtml(response);
    } else {
      return [];
    }
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
