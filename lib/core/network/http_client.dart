import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onsetway_services/constitem/const_url.dart';
import 'package:onsetway_services/core/network/header.dart';

import '../storage/token_helper.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => 'ApiException($statusCode, $message)';
}

class HttpClient {
  HttpClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final base = ConstUrl.baseUrl;
    return Uri.parse(
      '$base$path',
    ).replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')));
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final token = auth ? await TokenHelper.instance.read() : null;
    final resp = await _client.post(
      _uri(path),
      headers: Headers.buildHeaders(token),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );

    final text = resp.body.isEmpty ? '{}' : resp.body;
    final json = jsonDecode(text) as Map<String, dynamic>;
    if (resp.statusCode >= 200 && resp.statusCode < 300) return json;

    final msg = (json['message'] ?? 'Request failed') as String;
    throw ApiException(resp.statusCode, msg);
  }
}
