import 'dart:convert';
import 'local_data_source.dart';

abstract class CacheDataSource {
  Future<void> cacheJson(String key, Map<String, dynamic> data, {Duration? expiry});
  Future<Map<String, dynamic>?> getCachedJson(String key);
  Future<void> cacheString(String key, String data, {Duration? expiry});
  Future<String?> getCachedString(String key);
  Future<void> cacheObject<T>(String key, T object, {Duration? expiry});
  Future<T?> getCachedObject<T>(String key, T Function(Map<String, dynamic>) fromJson);
  Future<void> removeCache(String key);
  Future<void> clearExpiredCache();
  Future<void> clearAllCache();
}

class CacheDataSourceImpl implements CacheDataSource {
  final LocalDataSource _localDataSource;
  static const String _cachePrefix = 'cache_';
  static const String _expiryPrefix = 'expiry_';

  CacheDataSourceImpl(this._localDataSource);

  @override
  Future<void> cacheJson(String key, Map<String, dynamic> data, {Duration? expiry}) async {
    final cacheKey = _getCacheKey(key);
    final jsonString = json.encode(data);
    await _localDataSource.setString(cacheKey, jsonString);
    
    if (expiry != null) {
      await _setExpiry(key, expiry);
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedJson(String key) async {
    if (await _isExpired(key)) {
      await removeCache(key);
      return null;
    }
    
    final cacheKey = _getCacheKey(key);
    final jsonString = await _localDataSource.getString(cacheKey);
    
    if (jsonString == null) return null;
    
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      await removeCache(key);
      return null;
    }
  }

  @override
  Future<void> cacheString(String key, String data, {Duration? expiry}) async {
    final cacheKey = _getCacheKey(key);
    await _localDataSource.setString(cacheKey, data);
    
    if (expiry != null) {
      await _setExpiry(key, expiry);
    }
  }

  @override
  Future<String?> getCachedString(String key) async {
    if (await _isExpired(key)) {
      await removeCache(key);
      return null;
    }
    
    final cacheKey = _getCacheKey(key);
    return await _localDataSource.getString(cacheKey);
  }

  @override
  Future<void> cacheObject<T>(String key, T object, {Duration? expiry}) async {
    final Map<String, dynamic> data;
    
    if (object is Map<String, dynamic>) {
      data = object;
    } else if (object.toString().contains('toJson')) {
      // 假设对象有toJson方法
      try {
        data = (object as dynamic).toJson() as Map<String, dynamic>;
      } catch (e) {
        throw Exception('对象序列化失败: $e');
      }
    } else {
      throw Exception('不支持的对象类型');
    }
    
    await cacheJson(key, data, expiry: expiry);
  }

  @override
  Future<T?> getCachedObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final data = await getCachedJson(key);
    if (data == null) return null;
    
    try {
      return fromJson(data);
    } catch (e) {
      await removeCache(key);
      return null;
    }
  }

  @override
  Future<void> removeCache(String key) async {
    final cacheKey = _getCacheKey(key);
    final expiryKey = _getExpiryKey(key);
    
    await Future.wait([
      _localDataSource.remove(cacheKey),
      _localDataSource.remove(expiryKey),
    ]);
  }

  @override
  Future<void> clearExpiredCache() async {
    final allData = await _localDataSource.getAll();
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final keys = allData.keys.where((key) => key.startsWith(_cachePrefix));
    final deleteKeys = <String>[];
    
    for (final key in keys) {
      final originalKey = key.substring(_cachePrefix.length);
      final expiryKey = _getExpiryKey(originalKey);
      final expiryData = allData[expiryKey];
      
      if (expiryData != null) {
        final expiry = int.tryParse(expiryData.toString());
        if (expiry != null && now > expiry) {
          deleteKeys.add(key);
          deleteKeys.add(expiryKey);
        }
      }
    }
    
    for (final key in deleteKeys) {
      await _localDataSource.remove(key);
    }
  }

  @override
  Future<void> clearAllCache() async {
    final allData = await _localDataSource.getAll();
    final keys = allData.keys.where((key) => 
        key.startsWith(_cachePrefix) || key.startsWith(_expiryPrefix));
    
    for (final key in keys) {
      await _localDataSource.remove(key);
    }
  }

  String _getCacheKey(String key) => '$_cachePrefix$key';
  String _getExpiryKey(String key) => '$_expiryPrefix$key';

  Future<void> _setExpiry(String key, Duration expiry) async {
    final expiryKey = _getExpiryKey(key);
    final expiryTime = DateTime.now().millisecondsSinceEpoch + expiry.inMilliseconds;
    await _localDataSource.setInt(expiryKey, expiryTime);
  }

  Future<bool> _isExpired(String key) async {
    final expiryKey = _getExpiryKey(key);
    final expiryTime = await _localDataSource.getInt(expiryKey);
    
    if (expiryTime == null) return false;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    return now > expiryTime;
  }
}