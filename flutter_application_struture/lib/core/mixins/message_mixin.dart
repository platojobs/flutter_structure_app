import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter_application_struture/core/base/base_controller.dart';

final _logger = Logger();

/// 简单的消息混入
mixin MessageMixin {
  void showMessage(String message, {String? title}) {
    try {
      Get.snackbar(title ?? '提示', message);
    } catch (_) {
      _logger.i('${title ?? '提示'}: $message');
    }
  }

  void showError(String message, {String? title}) {
    try {
      Get.snackbar(title ?? '错误', message, backgroundColor: const Color(0x55FF0000));
    } catch (_) {
      _logger.e('错误: $message');
    }
  }

  void showSuccess(String message, {String? title}) {
    try {
      Get.snackbar(title ?? '成功', message, backgroundColor: const Color(0x5500AA00));
    } catch (_) {
      _logger.i('成功: $message');
    }
  }
}

/// 可选消息功能混入（用于 BaseController）
mixin OptionalMessageMixin<T> on BaseController<T> {
  Future<bool> showConfirm({
    required String title,
    required String message,
    String confirmText = '确定',
    String cancelText = '取消',
    bool barrierDismissible = true,
  }) async {
    if (!config.enableMessages) return false;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );

    return result ?? false;
  }

  Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
  }) async {
    return await Get.bottomSheet<T>(
      builder(Get.context!),
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  void showSnackbar({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition? snackPosition,
    Color? backgroundColor,
    Color? colorText,
  }) {
    if (!config.enableMessages) return;

    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 3),
      snackPosition: snackPosition ?? SnackPosition.bottom,
      backgroundColor: backgroundColor ?? Colors.grey[800],
      colorText: colorText ?? Colors.white,
    );
  }

  /// 显示错误提示
  void showError(String message, {String? title}) {
    if (!config.enableMessages) return;

    showSnackbar(
      title: title ?? '错误',
      message: message,
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// 显示成功提示
  void showSuccess(String message, {String? title}) {
    if (!config.enableMessages) return;

    showSnackbar(
      title: title ?? '成功',
      message: message,
      backgroundColor: Colors.green[400],
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// 显示普通提示
  void showMessage(String message, {String? title}) {
    if (!config.enableMessages) return;

    showSnackbar(
      title: title ?? '提示',
      message: message,
      backgroundColor: Colors.blue[400],
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
