import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_application_struture/core/config/loading_config.dart';
import 'package:flutter_application_struture/core/base/base_controller.dart';

/// 简单的 LoadingMixin（可直接用于 GetxController）
mixin LoadingMixin on GetxController {
  final RxBool _loading = false.obs;

  bool get loading => _loading.value;

  void setLoading(bool value) {
    _loading.value = value;
  }

  Future<R> runWithLoading<R>(Future<R> Function() action) async {
    try {
      setLoading(true);
      return await action();
    } finally {
      setLoading(false);
    }
  }
}

/// 可选的加载功能混入，用于 `BaseController<T>`
mixin OptionalLoadingMixin<T> on BaseController<T> {
  LoadingConfig? _loadingConfig;

  /// 配置加载（可选）
  void configLoading({LoadingConfig? loadingConfig}) {
    if (!this.config.enableLoading) return;

    _loadingConfig = loadingConfig ?? const LoadingConfig();
    _loadingConfig!.apply();

    // 设置回调到当前控制器
    setLoadingCallbacks(
      showLoading: _showLoading,
      dismissLoading: _dismissLoading,
      showSuccess: _showSuccess,
      showError: _showError,
      showProgress: _showProgress,
    );
  }

  /// 显示加载
  void _showLoading(String? text) {
    if (!config.enableLoading) return;

    EasyLoading.instance.userInteractions = !this.config.enableAutoLoading;
    EasyLoading.show(
      status: text ?? '加载中...',
      maskType: _loadingConfig?.maskType ?? EasyLoadingMaskType.black,
      dismissOnTap: _loadingConfig?.dismissOnTap ?? false,
    );
  }

  /// 隐藏加载
  void _dismissLoading() {
    if (!this.config.enableLoading) return;

    EasyLoading.dismiss();
    EasyLoading.instance.userInteractions = true;
  }

  /// 显示成功
  void _showSuccess(String message) {
    if (!this.config.enableMessages) return;

    EasyLoading.showSuccess(
      message,
      duration: _loadingConfig?.displayDuration ?? const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.none,
      dismissOnTap: true,
    );
  }

  /// 显示错误
  void _showError(String message) {
    if (!this.config.enableErrorDialog) return;

    EasyLoading.showError(
      message,
      duration: const Duration(seconds: 3),
      maskType: EasyLoadingMaskType.none,
    );
  }

  /// 显示进度
  void _showProgress(double progress, {String? status}) {
    if (!this.config.enableLoading) return;

    EasyLoading.showProgress(
      progress,
      status: status,
      maskType: _loadingConfig?.maskType ?? EasyLoadingMaskType.black,
    );
  }

  /// 显示Toast
  void showToast(String message,
      {Duration duration = const Duration(seconds: 2), EasyLoadingToastPosition position = EasyLoadingToastPosition.bottom}) {
    if (!this.config.enableMessages) return;

    EasyLoading.showToast(
      message,
      duration: duration,
      toastPosition: position,
    );
  }
}
