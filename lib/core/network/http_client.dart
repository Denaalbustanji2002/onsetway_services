import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:onsetway_services/constitem/const_url.dart';
import 'package:onsetway_services/core/network/header.dart';
import 'package:onsetway_services/core/storage/token_helper.dart';

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

  // -----------------------------
  // JSON GET (object)
  // -----------------------------
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? query,
    bool auth = false,
  }) async {
    final token = auth ? await TokenHelper.instance.read() : null;
    final resp = await _client.get(
      _uri(path, query),
      headers: Headers.buildHeaders(token, isJson: true),
    );
    return _decodeMapOrThrow(resp);
  }

  // -----------------------------
  // JSON GET (list)
  // -----------------------------
  Future<List<dynamic>> getJsonList(
    String path, {
    Map<String, dynamic>? query,
    bool auth = false,
  }) async {
    final token = auth ? await TokenHelper.instance.read() : null;
    final resp = await _client.get(
      _uri(path, query),
      headers: Headers.buildHeaders(token, isJson: true),
    );
    final decoded = _decodeRawOrThrow(resp);
    if (decoded is List) return decoded;
    throw ApiException(resp.statusCode, 'Expected list response');
  }

  // -----------------------------
  // JSON POST
  // -----------------------------
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final token = auth ? await TokenHelper.instance.read() : null;
    final resp = await _client.post(
      _uri(path),
      headers: Headers.buildHeaders(token, isJson: true),
      body: jsonEncode(body ?? const <String, dynamic>{}),
    );
    return _decodeMapOrThrow(resp);
  }

  // -----------------------------
  // JSON PUT
  // -----------------------------
  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final token = auth ? await TokenHelper.instance.read() : null;
    final resp = await _client.put(
      _uri(path),
      headers: Headers.buildHeaders(token, isJson: true),
      body: jsonEncode(body ?? const <String, dynamic>{}),
    );
    return _decodeMapOrThrow(resp);
  }

  // -----------------------------
  // JSON DELETE (with optional body)
  // -----------------------------
  Future<Map<String, dynamic>> deleteJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final token = auth ? await TokenHelper.instance.read() : null;
    final req = http.Request('DELETE', _uri(path))
      ..headers.addAll(Headers.buildHeaders(token, isJson: true))
      ..body = jsonEncode(body ?? const <String, dynamic>{});

    final streamed = await _client.send(req);
    final resp = await http.Response.fromStream(streamed);
    return _decodeMapOrThrow(resp);
  }

  // -----------------------------
  // Multipart POST (files upload)
  // -----------------------------
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    Map<String, File?> files = const {},
    bool auth = false,
  }) async {
    final token = auth ? await TokenHelper.instance.read() : null;

    final req = http.MultipartRequest('POST', _uri(path));
    // Important: do NOT set json content-type for multipart
    req.headers.addAll(Headers.buildHeaders(token, isJson: false));

    // fields
    fields.forEach((key, value) {
      req.fields.putIfAbsent(key, () => value);
    });

    // files (nullable)
    for (final entry in files.entries) {
      final file = entry.value;
      if (file != null) {
        req.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
      }
    }

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    return _decodeMapOrThrow(resp);
  }

  // -----------------------------
  // Helpers
  // -----------------------------
  Map<String, dynamic> _decodeMapOrThrow(http.Response resp) {
    final decoded = _decodeRawOrThrow(resp);
    if (decoded is Map<String, dynamic>) return decoded;
    throw ApiException(resp.statusCode, 'Unexpected response shape');
  }

  dynamic _decodeRawOrThrow(http.Response resp) {
    final text = resp.body.isEmpty ? '{}' : resp.body;
    final decoded = jsonDecode(text);
    if (resp.statusCode >= 200 && resp.statusCode < 300) return decoded;

    final msg = (decoded is Map && decoded['message'] is String)
        ? decoded['message'] as String
        : 'Request failed';
    throw ApiException(resp.statusCode, msg);
  }

  void close() => _client.close();
}
