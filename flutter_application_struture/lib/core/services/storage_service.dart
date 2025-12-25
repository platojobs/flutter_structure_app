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
}
