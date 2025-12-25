import 'package:flutter/foundation.dart';

/// 控制器配置选项
class ControllerConfig {
  final bool enableLoading;
  final bool enableAutoLoading;
  final bool enableMessages;
  final bool enableValidation;
  final bool enableErrorDialog;
  final bool enableCache;
  final bool enablePermission;

  const ControllerConfig({
    this.enableLoading = true,
    this.enableAutoLoading = true,
    this.enableMessages = true,
    this.enableValidation = false,
    this.enableErrorDialog = true,
    this.enableCache = false,
    this.enablePermission = false,
  });

  /// 预设配置
  static const ControllerConfig full = ControllerConfig(
    enableLoading: true,
    enableAutoLoading: true,
    enableMessages: true,
    enableValidation: true,
    enableErrorDialog: true,
    enableCache: true,
    enablePermission: true,
  );

  static const ControllerConfig silent = ControllerConfig(
    enableLoading: false,
    enableAutoLoading: false,
    enableMessages: false,
    enableValidation: false,
    enableErrorDialog: false,
  );

  static const ControllerConfig uiOnly = ControllerConfig(
    enableLoading: true,
    enableAutoLoading: false,
    enableMessages: false,
    enableErrorDialog: true,
  );

  /// 根据环境获取配置
  static ControllerConfig fromEnvironment() {
    if (kReleaseMode) {
      return const ControllerConfig(
        enableLoading: true,
        enableAutoLoading: false, // 生产环境不自动显示加载
        enableMessages: true,
        enableErrorDialog: true,
      );
    }
    return ControllerConfig.full; // 开发环境全功能
  }
}
