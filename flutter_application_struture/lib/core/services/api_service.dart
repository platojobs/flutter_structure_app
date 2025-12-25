import 'package:get/get.dart';

/// API 全局服务
class ApiService extends GetxService {
  final _isInitialized = false.obs;

  bool get isInitialized => _isInitialized.value;

  /// 初始化 API 服务
  Future<ApiService> init() async {
    // 模拟异步初始化（如建立连接池、初始化网络配置等）
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized.value = true;
    print('✅ ApiService initialized');
    return this;
  }

  /// 检查初始化状态
  Future<void> waitForInit() async {
    while (!_isInitialized.value) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
