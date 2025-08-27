import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onsetway_services/constitem/const_url.dart';
import 'package:onsetway_services/core/network/header.dart';

import '../storage/token_helper.dart';

import 'http_client.dart';

/// Use this for protected endpoints. It automatically attaches Bearer token.
class AuthorizedHttpClient {
  AuthorizedHttpClient({http.Client? client})
    : _client = client ?? http.Client();
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
  }) async {
    final token = await TokenHelper.instance.read();
    final resp = await _client.post(
      _uri(path),
      headers: Headers.buildHeaders(token),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    final text = resp.body.isEmpty ? '{}' : resp.body;
    final json = jsonDecode(text) as Map<String, dynamic>;
    if (resp.statusCode >= 200 && resp.statusCode < 300) return json;
    throw ApiException(
      resp.statusCode,
      (json['message'] ?? 'Request failed') as String,
    );
  }

  Future<Map<String, dynamic>> getJson(String path) async {
    final token = await TokenHelper.instance.read();
    final resp = await _client.get(
      _uri(path),
      headers: Headers.buildHeaders(token),
    );
    final text = resp.body.isEmpty ? '{}' : resp.body;
    final json = jsonDecode(text) as Map<String, dynamic>;
    if (resp.statusCode >= 200 && resp.statusCode < 300) return json;
    throw ApiException(
      resp.statusCode,
      (json['message'] ?? 'Request failed') as String,
    );
  }
}
