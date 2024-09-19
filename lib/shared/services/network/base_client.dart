import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseClient {
  var client = http.Client();
  static String baseUrl = 'http://www.gspns.co.rs';

  Map<String, String> basicHeaders = {
    "Accept": "application/json, text/plain, */*",
    "Content-Type": "application/json; charset=UTF-8",
  };

  Future<dynamic> get(String target, BuildContext context, {Map<String, String>? customHeaders}) async {
    var url = Uri.parse(baseUrl + target);
    Map<String, String> requestHeaders = Map.from(basicHeaders);

    if (customHeaders != null) {
      requestHeaders.addAll(customHeaders);
    }

    debugPrint("GET url: $url");
    try {
      var response = await client
          .get(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 5)); // Set timeout to 5 seconds
      debugPrint("status code: ${response.statusCode}");
      if (!context.mounted) return;

      if (response.headers['content-type']?.contains('application/json') == true) {
        return checkResponse(response, context);  // Parse as JSON if content type is JSON
      } else {
        // Return as a plain text (HTML) response if the content is not JSON
        return response.body;
      }
    } on TimeoutException catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request timed out. Please try again.', textAlign: TextAlign.center),
        ),
      );
      return null;
    } on SocketException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check your internet connection.', textAlign: TextAlign.center),
        ),
      );
      return null;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e', textAlign: TextAlign.center),
        ),
      );
      return null;
    }
  }

  dynamic checkResponse(dynamic response, BuildContext context) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);  // Only parse JSON responses
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}', textAlign: TextAlign.center),
          ),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to decode response: $e', textAlign: TextAlign.center),
        ),
      );
      return null;
    }
  }
}
