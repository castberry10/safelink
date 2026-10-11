import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SafeLinkService {
  static final _baseUrl = "${dotenv.env['SERVER_URL'] ?? 'http://10.0.2.2:11112'}/api";

  static const _jsonHeaders = {"Content-Type": "application/json"};

  static List<String> _parseThreatMsg(dynamic threatMsg) {
    if (threatMsg is List) return List<String>.from(threatMsg);
    final str = threatMsg?.toString().trim() ?? '';
    return str.isEmpty ? ['This page appears safe'] : [str];
  }

  /// Register a new user — returns message: userId / status: HTTP status code
  Future<Map<String, dynamic>> signUp(String username) async {
    final url = "$_baseUrl/users/register";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _jsonHeaders,
        body: json.encode({"username": username}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          "message": data["username"] ?? "No message",
          "status": response.statusCode,
        };
      } else {
        return {
          "message": ["Server response error: ${response.statusCode}"],
          "status": response.statusCode,
        };
      }
    } catch (e) {
      return {"message": ["Error occurred: $e"], "status": 500};
    }
  }

  /// Sign in an existing user — returns message: userId / status: HTTP status code
  Future<Map<String, dynamic>> signIn(String username) async {
    final url = "$_baseUrl/users/login";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _jsonHeaders,
        body: json.encode({"username": username}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          "message": data["username"] ?? "No message",
          "status": 200,
        };
      } else {
        return {
          "message": ["Server response error: ${response.statusCode}"],
          "status": response.statusCode,
        };
      }
    } catch (e) {
      return {"message": ["Error occurred: $e"], "status": 500};
    }
  }

  /// Inspect page content for suspicious elements (contact forms, credential inputs, etc.)
  Future<Map<String, dynamic>> checkPage({required String urlData}) async {
    final url = '$_baseUrl/check/page-content?websiteUrl=${Uri.encodeQueryComponent(urlData)}';

    try {
      final response = await http.get(Uri.parse(url), headers: _jsonHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          "result": data["result"],
          "message": _parseThreatMsg(data["threatMsg"]),
          "status": 200,
        };
      } else {
        return {
          "result": 4,
          "message": ["Server response error: ${response.statusCode}"],
          "status": response.statusCode,
        };
      }
    } catch (e) {
      return {"result": 4, "message": ["Error occurred: $e"], "status": 500};
    }
  }
}