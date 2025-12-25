// lib/core/config/loading_config.dart
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 加载动画配置
class LoadingConfig {
  final Duration displayDuration;
  final EasyLoadingIndicatorType indicatorType;
  final EasyLoadingStyle loadingStyle;
  final double indicatorSize;
  final double radius;
  final EasyLoadingMaskType maskType;
  final bool dismissOnTap;
  final bool userInteractions;
  
  const LoadingConfig({
    this.displayDuration = const Duration(milliseconds: 2000),
    this.indicatorType = EasyLoadingIndicatorType.dualRing,
    this.loadingStyle = EasyLoadingStyle.dark,
    this.indicatorSize = 45.0,
    this.radius = 10.0,
    this.maskType = EasyLoadingMaskType.black,
    this.dismissOnTap = false,
    this.userInteractions = false,
  });
  
  /// 应用到 EasyLoading
  void apply() {
    EasyLoading.instance
      ..displayDuration = displayDuration
      ..indicatorType = indicatorType
      ..loadingStyle = loadingStyle
      ..indicatorSize = indicatorSize
      ..radius = radius
      ..maskType = maskType
      ..dismissOnTap = dismissOnTap
      ..userInteractions = userInteractions;
  }
}