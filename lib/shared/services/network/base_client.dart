import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseClient {
  var client = http.Client();
  static String baseUrl = 'https://busnsapi.herokuapp.com';

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
      var response = await client.get(url, headers: requestHeaders);
      debugPrint("status code: ${response.statusCode}");
      if (!context.mounted) return;

      return checkResponse(response, context);
    } on TimeoutException catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A timeout exception')));
      return null;
    } on SocketException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Proverite internet konekciju')));
      return null;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Došlo je do greške: $e')));
      return null;
    }
  }

  dynamic checkResponse(dynamic response, BuildContext context) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Greška: ${response.statusCode}')));
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to decode response: $e')));
      return null;
    }
  }
}
