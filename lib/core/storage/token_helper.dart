import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHelper {
  TokenHelper._();
  static final TokenHelper instance = TokenHelper._();

  static final _k = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked),
  );

  static const _tokenKey = 'auth_token';
  static const _roleKey = 'auth_role';

  String? _tokenCache;
  String? _roleCache;

  Future<void> save(String token) async {
    // keep for backward compatibility
    _tokenCache = token;
    await _k.write(key: _tokenKey, value: token);
  }

  Future<void> saveSession({
    required String token,
    required String role,
  }) async {
    _tokenCache = token;
    _roleCache = role;
    await _k.write(key: _tokenKey, value: token);
    await _k.write(key: _roleKey, value: role);
  }

  Future<String?> read() async {
    _tokenCache ??= await _k.read(key: _tokenKey);
    return _tokenCache;
  }

  Future<String?> readRole() async {
    _roleCache ??= await _k.read(key: _roleKey);
    return _roleCache;
  }

  Future<void> clear() async {
    _tokenCache = null;
    _roleCache = null;
    await _k.delete(key: _tokenKey);
    await _k.delete(key: _roleKey);
  }
}
