import 'package:flutter/foundation.dart';

/// 环境配置枚举
enum Environment {
  development('development'),
  staging('staging'),
  production('production');

  const Environment(this.value);
  final String value;
}

/// 应用环境配置
class AppEnvironment {
  static Environment _current = Environment.development;
  static String _token = '';
  
  static Environment get current => _current;
  static String get token => _token;
  
  static bool get isDevelopment => _current == Environment.development;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProduction => _current == Environment.production;
  
  /// 初始化环境配置
  static void initialize({Environment? override}) {
    if (override != null) {
      _current = override;
    } else {
      // 默认从环境变量获取
      const env = String.fromEnvironment('ENV', defaultValue: 'development');
      _current = Environment.values.firstWhere(
        (e) => e.value == env,
        orElse: () => Environment.development,
      );
    }
    
    // 设置全局错误处理器
    if (isProduction) {
      FlutterError.onError = (details) {
        // 生产环境下记录错误但不显示
        FlutterError.presentError(details);
      };
    }
  }
  
  /// 设置认证令牌
  static void setToken(String token) {
    _token = token;
  }
  
  /// 清除认证令牌
  static void clearToken() {
    _token = '';
  }
  
  /// 获取API基础URL
  static String get apiBaseUrl {
    switch (_current) {
      case Environment.development:
        return 'https://api-dev.example.com';
      case Environment.staging:
        return 'https://api-staging.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }
  
  /// 获取日志级别
  static String get logLevel {
    switch (_current) {
      case Environment.development:
        return 'debug';
      case Environment.staging:
        return 'info';
      case Environment.production:
        return 'error';
    }
  }
  
  /// 是否启用调试功能
  static bool get enableDebug => isDevelopment || isStaging;
  
  /// 是否启用缓存
  static bool get enableCache => true;
  
  /// 是否启用离线模式
  static bool get enableOfflineMode => true;
}

/// 环境特定配置
class EnvironmentConfig {
  final bool enableCrashReporting;
  final bool enableAnalytics;
  final bool enablePerformanceMonitoring;
  final int cacheExpirationTime;
  final int requestTimeout;
  
  const EnvironmentConfig({
    this.enableCrashReporting = false,
    this.enableAnalytics = false,
    this.enablePerformanceMonitoring = false,
    this.cacheExpirationTime = 3600, // 1小时
    this.requestTimeout = 30000, // 30秒
  });
  
  static EnvironmentConfig get current {
    switch (AppEnvironment.current) {
      case Environment.development:
        return const EnvironmentConfig(
          enableCrashReporting: false,
          enableAnalytics: false,
          enablePerformanceMonitoring: true,
          cacheExpirationTime: 300, // 5分钟
          requestTimeout: 60000, // 60秒
        );
      case Environment.staging:
        return const EnvironmentConfig(
          enableCrashReporting: true,
          enableAnalytics: true,
          enablePerformanceMonitoring: true,
          cacheExpirationTime: 1800, // 30分钟
          requestTimeout: 45000, // 45秒
        );
      case Environment.production:
        return const EnvironmentConfig(
          enableCrashReporting: true,
          enableAnalytics: true,
          enablePerformanceMonitoring: true,
          cacheExpirationTime: 3600, // 1小时
          requestTimeout: 30000, // 30秒
        );
    }
  }
}