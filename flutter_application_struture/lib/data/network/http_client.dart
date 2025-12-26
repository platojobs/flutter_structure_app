import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_application_struture/core/config/environment.dart';

/// HTTP请求响应类
class ApiResponse {
  final bool success;
  final int? statusCode;
  final Map<String, dynamic>? data;
  final String? errorMessage;

  ApiResponse({
    required this.success,
    this.statusCode,
    this.data,
    this.errorMessage,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'],
      data: json['data'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'data': data,
      'errorMessage': errorMessage,
    };
  }
}

/// HTTP客户端类
class HttpClient {
  late final Dio _dio;
  final EnvironmentConfig _config;

  HttpClient(this._config) {
    _dio = Dio(BaseOptions(
      baseUrl: AppEnvironment.apiBaseUrl,
      connectTimeout: Duration(milliseconds: _config.requestTimeout),
      receiveTimeout: Duration(milliseconds: _config.requestTimeout),
      sendTimeout: Duration(milliseconds: _config.requestTimeout),
      headers: {
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.json,
    ));

    _setupInterceptors();
  }

  /// 设置拦截器
  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 添加认证令牌
        final token = AppEnvironment.token;
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // 错误处理
        _handleError(error);
        handler.next(error);
      },
    ));
  }

  /// 错误处理
  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw Exception('连接超时，请检查网络');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case HttpStatus.unauthorized:
            throw Exception('认证失败，请重新登录');
          case HttpStatus.forbidden:
            throw Exception('没有权限执行此操作');
          case HttpStatus.notFound:
            throw Exception('请求的资源不存在');
          case HttpStatus.internalServerError:
            throw Exception('服务器内部错误');
          default:
            throw Exception('请求失败，状态码：$statusCode');
        }
      case DioExceptionType.cancel:
        throw Exception('请求已取消');
      case DioExceptionType.connectionError:
        throw Exception('网络连接错误');
      default:
        throw Exception('未知错误');
    }
  }

  /// GET请求
  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return ApiResponse(
        success: response.statusCode == 200,
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        statusCode: e.response?.statusCode,
        errorMessage: e.message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// POST请求
  Future<ApiResponse> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse(
        success: response.statusCode == 200 || response.statusCode == 201,
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        statusCode: e.response?.statusCode,
        errorMessage: e.message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// PUT请求
  Future<ApiResponse> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse(
        success: response.statusCode == 200,
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        statusCode: e.response?.statusCode,
        errorMessage: e.message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// PATCH请求
  Future<ApiResponse> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse(
        success: response.statusCode == 200,
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        statusCode: e.response?.statusCode,
        errorMessage: e.message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// DELETE请求
  Future<ApiResponse> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse(
        success: response.statusCode == 200,
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        statusCode: e.response?.statusCode,
        errorMessage: e.message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 设置认证令牌
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// 清除认证令牌
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}