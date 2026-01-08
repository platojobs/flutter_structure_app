// lib/core/exceptions/exception_handler.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_struture/core/exceptions/app_exceptions.dart';
import 'package:flutter_application_struture/core/utils/logger.dart';
import 'package:flutter_application_struture/core/config/environment.dart';

/// 异常处理器
class ExceptionHandler {
  static ExceptionHandler? _instance;
  static ExceptionHandler get instance => _instance ??= ExceptionHandler._();
  
  ExceptionHandler._();

  /// 处理异常
  void handleException(dynamic error, {StackTrace? stackTrace}) {
    final exception = ExceptionFactory.create(error);
    
    // 记录异常日志
    AppLogger.error('Exception occurred', error: error, stackTrace: stackTrace);
    
    // 根据异常类型进行处理
    switch (exception.runtimeType) {
      case NetworkException:
        _handleNetworkException(exception as NetworkException);
        break;
      case AuthException:
        _handleAuthException(exception as AuthException);
        break;
      case ServerException:
        _handleServerException(exception as ServerException);
        break;
      case ValidationException:
        _handleValidationException(exception as ValidationException);
        break;
      case PermissionException:
        _handlePermissionException(exception as PermissionException);
        break;
      default:
        _handleUnknownException(exception);
    }
  }

  /// 处理网络异常
  void _handleNetworkException(NetworkException exception) {
    if (AppEnvironment.isDevelopment) {
      Get.snackbar(
        '网络错误',
        exception.message,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
    
    // 这里可以添加重试逻辑
    _showGenericError(exception.message);
  }

  /// 处理认证异常
  void _handleAuthException(AuthException exception) {
    // 清除用户token
    _clearUserSession();
    
    // 跳转到登录页面
    if (Get.currentRoute != '/login') {
      Get.offAllNamed('/login');
    }
    
    Get.snackbar(
      '认证失败',
      exception.message,
      backgroundColor: Colors.orange.shade400,
      colorText: Colors.white,
    );
  }

  /// 处理服务器异常
  void _handleServerException(ServerException exception) {
    if (exception.code == '404') {
      _showGenericError('页面不存在');
      return;
    }
    
    _showGenericError(exception.message);
  }

  /// 处理数据验证异常
  void _handleValidationException(ValidationException exception) {
    Get.snackbar(
      '输入错误',
      exception.message,
      backgroundColor: Colors.orange.shade400,
      colorText: Colors.white,
    );
  }

  /// 处理权限异常
  void _handlePermissionException(PermissionException exception) {
    Get.snackbar(
      '权限不足',
      exception.message,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
    );
  }

  /// 处理未知异常
  void _handleUnknownException(AppException exception) {
    if (AppEnvironment.isDevelopment) {
      Get.snackbar(
        '未知错误',
        exception.message,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } else {
      _showGenericError('操作失败，请稍后重试');
    }
  }

  /// 显示通用错误信息
  void _showGenericError(String message) {
    Get.snackbar(
      '错误',
      message,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// 清除用户会话
  void _clearUserSession() {
    // 清除本地存储的用户信息
    // 这里可以调用存储服务来清除token等信息
  }

  /// 安全执行异步操作
  Future<T?> safeExecute<T>(
    Future<T> Function() operation, {
    String? errorMessage,
    bool showErrorDialog = true,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      handleException(error, stackTrace: stackTrace);
      
      if (showErrorDialog && errorMessage != null) {
        _showGenericError(errorMessage);
      }
      
      return null;
    }
  }

  /// 安全执行同步操作
  T? safeExecuteSync<T>(
    T Function() operation, {
    String? errorMessage,
    bool showErrorDialog = true,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      handleException(error, stackTrace: stackTrace);
      
      if (showErrorDialog && errorMessage != null) {
        _showGenericError(errorMessage);
      }
      
      return null;
    }
  }
}