import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 统一 token 管理服务，基于 FlutterSecureStorage
class TokenService {
  final FlutterSecureStorage _storage;
  static const _keyAuthToken = 'auth_token';
  
  /// 缓存的 token（用于快速检查）
  String? _cachedToken;

  TokenService(this._storage);

  /// 检查是否有有效的 token
  bool get hasToken => _cachedToken != null && _cachedToken!.isNotEmpty;

  /// 保存 token
  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _keyAuthToken, value: token);
  }

  /// 读取 token
  Future<String?> readToken() async {
    _cachedToken ??= await _storage.read(key: _keyAuthToken);
    return _cachedToken;
  }

  /// 清除 token
  Future<void> clearToken() async {
    _cachedToken = null;
    await _storage.delete(key: _keyAuthToken);
  }

  /// 初始化时加载缓存的 token
  Future<void> initialize() async {
    _cachedToken = await _storage.read(key: _keyAuthToken);
  }
}
