import 'package:dio/dio.dart';
import '../../../core/exceptions/app_exceptions.dart' show ServerException, NetworkException, ValidationException, AuthException;
import '../../../core/utils/logger.dart';

abstract class RemoteDataSource {
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? queryParameters});
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> patch(String endpoint, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, dynamic>? data});
  Future<void> download(String url, String savePath, {Map<String, dynamic>? queryParameters});
  void setAuthToken(String token);
  void removeAuthToken();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio _dio;
  static const int _connectTimeout = 30000;
  static const int _receiveTimeout = 30000;
  static const int _sendTimeout = 30000;

  RemoteDataSourceImpl({required String baseUrl}) : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(milliseconds: _connectTimeout),
    receiveTimeout: const Duration(milliseconds: _receiveTimeout),
    sendTimeout: const Duration(milliseconds: _sendTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // 请求拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        AppLogger.info('发送请求: ${options.method} ${options.uri}');
        AppLogger.debug('请求参数: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.info('请求成功: ${response.statusCode} ${response.requestOptions.uri}');
        AppLogger.debug('响应数据: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        AppLogger.error('请求失败: ${error.response?.statusCode} ${error.requestOptions.uri}');
        AppLogger.debug('错误信息: ${error.message}');
        AppLogger.debug('响应数据: ${error.response?.data}');
        handler.next(error);
      },
    ));
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> patch(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.patch(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<void> download(String url, String savePath, {Map<String, dynamic>? queryParameters}) async {
    try {
      await _dio.download(url, savePath, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '下载失败: $e');
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    
    if (statusCode >= 200 && statusCode < 300) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      } else {
        return {'data': data};
      }
    } else {
      throw _createHttpException(statusCode, response.data);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: '网络连接超时');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        return _createHttpException(statusCode, error.response?.data);
      case DioExceptionType.cancel:
        return ServerException(message: '请求已取消');
      case DioExceptionType.connectionError:
        return NetworkException(message: '网络连接错误');
      case DioExceptionType.unknown:
      default:
        return ServerException(message: '未知网络错误');
    }
  }

  AppException _createHttpException(int statusCode, dynamic data) {
    String message = 'HTTP错误 $statusCode';
    
    if (data != null) {
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['error'] ?? message;
      } else if (data is String) {
        message = data;
      }
    }

    switch (statusCode) {
      case 400:
        return ValidationException(message: message);
      case 401:
        return AuthException(message: '认证失败');
      case 403:
        return AuthException(message: '权限不足');
      case 404:
        return ServerException(message: '资源未找到');
      case 422:
        return ValidationException(message: message);
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(message: '服务器错误');
      default:
        return ServerException(message: message);
    }
  }

  @override
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}