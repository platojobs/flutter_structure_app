import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();
  static final AppLogger instance = AppLogger._();

  // 静态方法以便于使用
  static void info(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'INFO');
  }

  static void debug(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'DEBUG');
  }

  static void warn(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'WARN');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    developer.log(message, name: tag ?? 'ERROR', error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'WARN');
  }
}
