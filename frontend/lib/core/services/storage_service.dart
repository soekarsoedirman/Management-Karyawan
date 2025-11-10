import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();
  static const _keyToken = 'auth_token';
  static const _keyRefresh = 'refresh_token';
  static const _keyUser = 'auth_user_json';

  Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);
  Future<String?> readToken() => _storage.read(key: _keyToken);
  Future<void> deleteToken() => _storage.delete(key: _keyToken);

  Future<void> saveRefreshToken(String rt) =>
      _storage.write(key: _keyRefresh, value: rt);
  Future<String?> readRefreshToken() => _storage.read(key: _keyRefresh);

  Future<void> saveUserJson(String json) =>
      _storage.write(key: _keyUser, value: json);
  Future<String?> readUserJson() => _storage.read(key: _keyUser);
  Future<void> deleteUserJson() => _storage.delete(key: _keyUser);
}
