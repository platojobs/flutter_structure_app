import 'package:dio/dio.dart';
import 'interceptors.dart';
import 'response_handler.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(String baseUrl)
      : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.addAll([
      LoggingInterceptor(),
      // AuthInterceptor() can be added when token storage is available
    ]);
  }

  Future<ApiResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    final resp = await _dio.get(path, queryParameters: queryParameters, options: options);
    return ApiResponse<T>.fromDioResponse(resp);
  }

  Future<ApiResponse<T>> post<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    final resp = await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    return ApiResponse<T>.fromDioResponse(resp);
  }

  // expose Dio when needed
  Dio get dio => _dio;
}
