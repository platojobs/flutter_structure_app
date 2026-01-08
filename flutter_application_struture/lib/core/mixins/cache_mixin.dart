// lib/core/mixins/cache_mixin.dart
import 'package:get/get.dart';
import 'package:flutter_application_struture/core/services/storage_service.dart';

/// 缓存管理混入
mixin CacheMixin on GetxController {
  StorageService? _storageService;

  /// 初始化存储服务
  void initCache(StorageService storageService) {
    _storageService = storageService;
  }

  /// 缓存字符串数据
  Future<bool> cacheString(String key, String value) async {
    if (_storageService == null) return false;
    return await _storageService!.setString(key, value);
  }

  /// 获取缓存的字符串数据
  Future<String?> getCachedString(String key) async {
    if (_storageService == null) return null;
    return await _storageService!.getString(key);
  }

  /// 缓存JSON数据
  Future<bool> cacheJson(String key, Map<String, dynamic> data) async {
    if (_storageService == null) return false;
    return await _storageService!.setJson(key, data);
  }

  /// 获取缓存的JSON数据
  Future<Map<String, dynamic>?> getCachedJson(String key) async {
    if (_storageService == null) return null;
    return await _storageService!.getJson(key);
  }

  /// 缓存对象数据
  Future<bool> cacheObject<T>(String key, T object) async {
    if (_storageService == null) return false;
    return await _storageService!.setObject(key, object);
  }

  /// 获取缓存的对象数据
  Future<T?> getCachedObject<T>(String key) async {
    if (_storageService == null) return null;
    return await _storageService!.getObject<T>(key);
  }

  /// 缓存列表数据
  Future<bool> cacheList<T>(String key, List<T> list) async {
    if (_storageService == null) return false;
    return await _storageService!.setList(key, list);
  }

  /// 获取缓存的列表数据
  Future<List<T>?> getCachedList<T>(String key) async {
    if (_storageService == null) return null;
    return await _storageService!.getList<T>(key);
  }

  /// 删除缓存
  Future<bool> removeCache(String key) async {
    if (_storageService == null) return false;
    return await _storageService!.remove(key);
  }

  /// 清空所有缓存
  Future<bool> clearCache() async {
    if (_storageService == null) return false;
    return await _storageService!.clear();
  }

  /// 检查是否存在缓存
  Future<bool> hasCache(String key) async {
    if (_storageService == null) return false;
    return await _storageService!.containsKey(key);
  }

  /// 获取所有缓存键
  Future<List<String>> getAllCacheKeys() async {
    if (_storageService == null) return [];
    return await _storageService!.getAllKeys();
  }

  /// 缓存用户数据
  Future<bool> cacheUserData(Map<String, dynamic> userData) async {
    return await cacheJson('user_data', userData);
  }

  /// 获取用户数据
  Future<Map<String, dynamic>?> getUserData() async {
    return await getCachedJson('user_data');
  }

  /// 缓存令牌
  Future<bool> cacheToken(String token) async {
    return await cacheString('auth_token', token);
  }

  /// 获取令牌
  Future<String?> getToken() async {
    return await getCachedString('auth_token');
  }

  /// 缓存用户偏好设置
  Future<bool> cachePreferences(Map<String, dynamic> preferences) async {
    return await cacheJson('user_preferences', preferences);
  }

  /// 获取用户偏好设置
  Future<Map<String, dynamic>?> getPreferences() async {
    return await getCachedJson('user_preferences');
  }

  /// 缓存临时数据（带过期时间）
  Future<bool> cacheWithExpiry(String key, String value, Duration expiry) async {
    final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
    final data = {
      'value': value,
      'expiry': expiryTime,
    };
    return await cacheJson(key, data);
  }

  /// 获取带过期时间的缓存数据
  Future<String?> getCachedWithExpiry(String key) async {
    final data = await getCachedJson(key);
    if (data == null) return null;

    final expiry = data['expiry'] as int?;
    final value = data['value'] as String?;

    if (expiry == null || value == null) {
      // 删除无效的缓存数据
      await removeCache(key);
      return null;
    }

    // 检查是否过期
    if (DateTime.now().millisecondsSinceEpoch > expiry) {
      await removeCache(key);
      return null;
    }

    return value;
  }

  /// 检查缓存是否过期
  bool isExpired(int expiryTime) {
    return DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  /// 批量删除缓存
  Future<bool> removeMultipleCaches(List<String> keys) async {
    if (_storageService == null) return false;
    
    var success = true;
    for (final key in keys) {
      final result = await _storageService!.remove(key);
      success = success && result;
    }
    return success;
  }

  /// 清理过期缓存
  Future<void> cleanExpiredCache() async {
    final keys = await getAllCacheKeys();
    for (final key in keys) {
      try {
        await getCachedWithExpiry(key);
      } catch (e) {
        // 忽略清理过程中的错误
      }
    }
  }
}

/// 缓存策略枚举
enum CacheStrategy {
  /// 只从缓存获取
  cacheOnly,
  /// 只从网络获取
  networkOnly,
  /// 优先缓存，失败则从网络获取
  cacheFirst,
  /// 优先网络，失败则从缓存获取
  networkFirst,
  /// 先获取缓存，同时更新网络数据
  cacheThenNetwork,
}

/// 缓存管理器混入
mixin CacheManagerMixin on GetxController {
  StorageService? _storageService;
  final Map<String, DateTime> _cacheTimestamps = <String, DateTime>{};
  final Map<String, Duration> _cacheExpiry = <String, Duration>{};

  /// 初始化缓存管理器
  void initCacheManager(StorageService storageService) {
    _storageService = storageService;
  }

  /// 设置缓存过期时间
  void setCacheExpiry(String key, Duration expiry) {
    _cacheExpiry[key] = expiry;
  }

  /// 缓存数据并记录时间戳
  Future<bool> cacheWithTimestamp<T>(String key, T data) async {
    if (_storageService == null) return false;

    final success = await _storageService!.setObject(key, data);
    if (success) {
      _cacheTimestamps[key] = DateTime.now();
    }
    return success;
  }

  /// 获取缓存数据（检查过期时间）
  Future<T?> getCachedWithExpiryCheck<T>(String key) async {
    if (_storageService == null) return null;

    // 检查是否有自定义过期时间
    final customExpiry = _cacheExpiry[key];
    if (customExpiry != null) {
      final cachedData = await _storageService!.getObject<T>(key);
      if (cachedData != null) {
        final timestamp = _cacheTimestamps[key];
        if (timestamp != null) {
          final expiryTime = timestamp.add(customExpiry);
          if (DateTime.now().isBefore(expiryTime)) {
            return cachedData;
          } else {
            // 已过期，删除缓存
            await _storageService!.remove(key);
          }
        }
      }
    }

    return await _storageService!.getObject<T>(key);
  }

  /// 缓存数据（带策略）
  Future<T?> cacheWithStrategy<T>(
    String key,
    Future<T> Function() fetchData,
    CacheStrategy strategy, {
    Duration? expiry,
  }) async {
    switch (strategy) {
      case CacheStrategy.cacheOnly:
        return await getCachedWithExpiryCheck<T>(key);
      
      case CacheStrategy.networkOnly:
        final data = await fetchData();
        await cacheWithTimestamp(key, data);
        if (expiry != null) setCacheExpiry(key, expiry);
        return data;
      
      case CacheStrategy.cacheFirst:
        var cachedData = await getCachedWithExpiryCheck<T>(key);
        if (cachedData != null) {
          return cachedData;
        }
        final data = await fetchData();
        await cacheWithTimestamp(key, data);
        if (expiry != null) setCacheExpiry(key, expiry);
        return data;
      
      case CacheStrategy.networkFirst:
        try {
          final data = await fetchData();
          await cacheWithTimestamp(key, data);
          if (expiry != null) setCacheExpiry(key, expiry);
          return data;
        } catch (e) {
          // 网络失败，尝试从缓存获取
          return await getCachedWithExpiryCheck<T>(key);
        }
      
      case CacheStrategy.cacheThenNetwork:
        final cachedData = await getCachedWithExpiryCheck<T>(key);
        // 异步更新缓存
        fetchData().then((data) async {
          await cacheWithTimestamp(key, data);
          if (expiry != null) setCacheExpiry(key, expiry);
        }).catchError((_) {});
        return cachedData;
    }
  }
}