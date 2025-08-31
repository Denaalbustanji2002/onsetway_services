import 'package:onsetway_services/core/network/http_client.dart';

/// Thin wrapper that always attaches the JWT via [auth: true].
class AuthorizedHttpClient {
  final HttpClient _base;

  /// Preferred: pass an existing base client (named param).
  AuthorizedHttpClient({HttpClient? base}) : _base = base ?? HttpClient();

  /// Convenience factory if you like `fromBase(http)`.
  factory AuthorizedHttpClient.fromBase(HttpClient base) =>
      AuthorizedHttpClient(base: base);

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? query,
  }) => _base.getJson(path, query: query, auth: true);

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) => _base.postJson(path, body: body, auth: true);

  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  }) => _base.putJson(path, body: body, auth: true);

  Future<Map<String, dynamic>> deleteJson(
    String path, {
    Map<String, dynamic>? body,
  }) => _base.deleteJson(path, body: body, auth: true);
}
