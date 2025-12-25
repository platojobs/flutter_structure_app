import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_struture/data/network/api_client.dart';
import 'package:flutter_application_struture/data/network/interceptors.dart';

void main() {
  test('ApiClient sets baseUrl and registers LoggingInterceptor', () {
    final client = ApiClient('https://example.test');
    expect(client.dio.options.baseUrl, 'https://example.test');

    final hasLogging = client.dio.interceptors.any((i) => i is LoggingInterceptor);
    expect(hasLogging, true);
  });
}
