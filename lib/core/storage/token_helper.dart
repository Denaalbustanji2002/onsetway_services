import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHelper {
  TokenHelper._();
  static final TokenHelper instance = TokenHelper._();

  static final _k = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked),
  );

  static const _tokenKey = 'auth_token';
  String? _cache;

  Future<void> save(String token) async {
    _cache = token;
    await _k.write(key: _tokenKey, value: token);
  }

  Future<String?> read() async {
    if (_cache != null) return _cache;
    _cache = await _k.read(key: _tokenKey);
    return _cache;
  }

  Future<void> clear() async {
    _cache = null;
    await _k.delete(key: _tokenKey);
  }
}
