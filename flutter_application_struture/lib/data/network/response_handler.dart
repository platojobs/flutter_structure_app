import 'package:dio/dio.dart';

class ApiResponse<T> {
  final T? data;
  final int? statusCode;

  ApiResponse({this.data, this.statusCode});

  factory ApiResponse.fromDioResponse(Response resp) {
    return ApiResponse(data: resp.data as T?, statusCode: resp.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}
