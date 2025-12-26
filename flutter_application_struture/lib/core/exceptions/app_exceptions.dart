// lib/core/exceptions/app_exceptions.dart
/// 应用异常基类
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message';
}

/// 网络异常
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// 认证异常
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// 数据验证异常
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// 服务器错误异常
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// 缓存异常
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// 权限异常
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// 文件异常
class FileException extends AppException {
  const FileException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// 未知异常
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// 异常工厂类
class ExceptionFactory {
  /// 根据错误类型创建对应的异常
  static AppException create(dynamic error, {String? customMessage}) {
    if (error is AppException) {
      return error;
    }

    if (error.toString().toLowerCase().contains('network')) {
      return NetworkException(
        message: customMessage ?? '网络连接失败，请检查网络设置',
        originalError: error,
      );
    }

    if (error.toString().toLowerCase().contains('timeout')) {
      return NetworkException(
        message: customMessage ?? '请求超时，请稍后重试',
        originalError: error,
      );
    }

    if (error.toString().toLowerCase().contains('401') || 
        error.toString().toLowerCase().contains('unauthorized')) {
      return AuthException(
        message: customMessage ?? '认证失败，请重新登录',
        code: '401',
        originalError: error,
      );
    }

    if (error.toString().toLowerCase().contains('403') || 
        error.toString().toLowerCase().contains('forbidden')) {
      return PermissionException(
        message: customMessage ?? '没有权限执行此操作',
        code: '403',
        originalError: error,
      );
    }

    if (error.toString().toLowerCase().contains('404') || 
        error.toString().toLowerCase().contains('not found')) {
      return ServerException(
        message: customMessage ?? '请求的资源不存在',
        code: '404',
        originalError: error,
      );
    }

    if (error.toString().toLowerCase().contains('500') || 
        error.toString().toLowerCase().contains('internal server error')) {
      return ServerException(
        message: customMessage ?? '服务器内部错误，请稍后重试',
        code: '500',
        originalError: error,
      );
    }

    return UnknownException(
      message: customMessage ?? '发生未知错误',
      originalError: error,
    );
  }

  /// 创建自定义异常
  static AppException custom(String message, {String? code, dynamic originalError}) {
    return AppException(
      message: message,
      code: code,
      originalError: originalError,
    );
  }
}