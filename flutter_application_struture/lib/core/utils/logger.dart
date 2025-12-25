import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();
  static final AppLogger instance = AppLogger._();

  void info(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'INFO');
  }

  void debug(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'DEBUG');
  }

  void warn(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'WARN');
  }

  void error(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    developer.log(message, name: tag ?? 'ERROR', error: error, stackTrace: stackTrace);
  }
}
