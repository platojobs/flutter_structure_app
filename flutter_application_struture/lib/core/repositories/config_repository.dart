import 'package:flutter_application_struture/core/base/base_repository.dart';

/// 应用配置仓库（全局单例）
class ConfigRepository extends BaseRepository {
  /// 模拟配置数据
  static const Map<String, dynamic> _mockConfig = {
    'appName': '企业级Flutter应用',
    'version': '1.0.0',
    'apiVersion': 'v1',
    'enableFeatures': {
      'analytics': true,
      'crashReporting': true,
      'offlineMode': true,
    },
  };

  /// 获取应用配置
  Future<Map<String, dynamic>> getAppConfig() async {
    // 模拟 API 调用
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockConfig;
  }

  /// 获取单个配置项
  Future<dynamic> getConfigValue(String key) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockConfig[key];
  }

  /// 更新配置
  Future<bool> updateConfig(Map<String, dynamic> config) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
