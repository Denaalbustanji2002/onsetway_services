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
  // Centralized decode: ALWAYS returns a Map on success.
  // If the body is a list/primitive, it is wrapped under {"data": decoded}.
  // -----------------------------
  Map<String, dynamic> _decodeOrThrow(http.Response resp) {
    final text = resp.body.isEmpty ? '{}' : resp.body;

    dynamic decoded;
    try {
      decoded = jsonDecode(text);
    } catch (_) {
      decoded = <String, dynamic>{}; // body wasn't JSON; treat like empty map
    }

    final Map<String, dynamic> payload = (decoded is Map<String, dynamic>)
        ? decoded
        : <String, dynamic>{'data': decoded};

    if (resp.statusCode >= 200 && resp.statusCode < 300) return payload;

    final msg = (payload['message'] is String)
        ? payload['message'] as String
        : 'Request failed';
    throw ApiException(resp.statusCode, msg);
  }

  // Convenience if you specifically want a List:
  Future<List<dynamic>> _ensureList(Future<Map<String, dynamic>> fut) async {
    final m = await fut;
    final d = m['data'];
    if (d is List) return d;
    throw ApiException(200, 'Expected list response under "data"');
  }

  // -----------------------------
  // JSON GET/POST/PUT/DELETE
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
    return _decodeOrThrow(resp);
  }

  Future<List<dynamic>> getJsonList(
    String path, {
    Map<String, dynamic>? query,
    bool auth = false,
  }) => _ensureList(getJson(path, query: query, auth: auth));

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
    return _decodeOrThrow(resp);
  }

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
    return _decodeOrThrow(resp);
  }

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
    return _decodeOrThrow(resp);
  }

  // -----------------------------
  // Multipart POST (files upload)
  // files: map of form-field name -> File? (null entries are ignored)
  // -----------------------------
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    Map<String, File?> files = const {},
    bool auth = false,
  }) async {
    final token = auth ? await TokenHelper.instance.read() : null;

    final req = http.MultipartRequest('POST', _uri(path));
    // IMPORTANT: do NOT set a JSON content type for multipart;
    // let MultipartRequest set its own boundary/content-type.
    req.headers.addAll(Headers.buildHeaders(token, isJson: false));

    fields.forEach((k, v) => req.fields[k] = v);

    for (final entry in files.entries) {
      final file = entry.value;
      if (file != null) {
        req.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
      }
    }

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    return _decodeOrThrow(resp);
  }

  void close() => _client.close();
}
