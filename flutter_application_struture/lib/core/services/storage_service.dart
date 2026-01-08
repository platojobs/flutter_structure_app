import 'dart:convert';
import 'package:get/get.dart';

/// 本地存储服务
class StorageService extends GetxService {
  final _isInitialized = false.obs;
  final _cache = <String, dynamic>{};

  bool get isInitialized => _isInitialized.value;

  /// 初始化存储服务
  Future<StorageService> init() async {
    // 模拟异步初始化（如初始化本地数据库等）
    await Future.delayed(const Duration(milliseconds: 300));
    _isInitialized.value = true;
    print('✅ StorageService initialized');
    return this;
  }

  /// 保存数据
  void saveData<T>(String key, T value) {
    _cache[key] = value;
  }

  /// 读取数据
  T? getData<T>(String key) {
    return _cache[key] as T?;
  }

  /// 删除数据
  void removeData(String key) {
    _cache.remove(key);
  }

  /// 清空缓存
  void clearAll() {
    _cache.clear();
  }

  /// 检查初始化状态
  Future<void> waitForInit() async {
    while (!_isInitialized.value) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  // 添加缺失的方法以支持 CacheMixin
  Future<bool> setString(String key, String value) async {
    _cache[key] = value;
    return true;
  }

  Future<String?> getString(String key) async {
    final value = _cache[key];
    return value is String ? value : null;
  }

  Future<bool> setJson(String key, Map<String, dynamic> data) async {
    _cache[key] = jsonEncode(data);
    return true;
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final value = _cache[key];
    if (value is String) {
      try {
        return jsonDecode(value) as Map<String, dynamic>?;
      } catch (e) {
        return null;
      }
    }
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  Future<bool> setObject<T>(String key, T object) async {
    _cache[key] = jsonEncode(object);
    return true;
  }

  Future<T?> getObject<T>(String key) async {
    final value = _cache[key];
    if (value is String) {
      try {
        return jsonDecode(value) as T?;
      } catch (e) {
        return null;
      }
    }
    return value as T?;
  }

  Future<bool> setList<T>(String key, List<T> list) async {
    _cache[key] = jsonEncode(list);
    return true;
  }

  Future<List<T>?> getList<T>(String key) async {
    final value = _cache[key];
    if (value is String) {
      try {
        return List<T>.from(jsonDecode(value));
      } catch (e) {
        return null;
      }
    }
    return value is List ? List<T>.from(value) : null;
  }

  Future<bool> remove(String key) async {
    _cache.remove(key);
    return true;
  }

  Future<bool> clear() async {
    _cache.clear();
    return true;
  }

  Future<bool> containsKey(String key) async {
    return _cache.containsKey(key);
  }

  Future<List<String>> getAllKeys() async {
    return _cache.keys.toList();
  }
}
