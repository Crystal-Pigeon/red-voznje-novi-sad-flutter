import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

const String fallbackUrl = 'http://www.gspns.co.rs/red-voznje/gradski';

Future<String?> fetchDateFromHtml() async {
  try {
    final fallbackResponse = await http.get(Uri.parse(fallbackUrl));

    if (fallbackResponse.statusCode == 200) {
      final document = html_parser.parse(fallbackResponse.body);

      final selectElement = document.getElementById('vaziod');
      if (selectElement != null) {
        final optionElement =
            selectElement.getElementsByTagName('option').first;
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
      debugPrint(
          'Fallback HTML page returned error: ${fallbackResponse.statusCode}');
    }
  } catch (e) {
    debugPrint('Error fetching date from fallback HTML: $e');
  }

  try {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetchAndActivate();

    final String remoteConfigValue = remoteConfig.getString('vazi_od');
    debugPrint('Fetched value from Firebase Remote Config: $remoteConfigValue');
    return remoteConfigValue;
  } catch (e) {
    debugPrint('Error fetching value from Firebase Remote Config: $e');
    return null;
  }
}
