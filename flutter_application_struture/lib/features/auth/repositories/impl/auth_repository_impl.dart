import 'package:flutter_application_struture/data/network/api_client.dart';
import 'package:flutter_application_struture/core/services/token_service.dart';
import '../auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final TokenService tokenService;

  AuthRepositoryImpl(this.apiClient, this.tokenService);

  @override
  Future<String> login(String email, String password) async {
    final resp = await apiClient.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    // 假设后端返回 { data: { token: '...' } }
    final data = resp.data;
    if (data != null && data['token'] != null) {
      final token = data['token'] as String;
      // 持久化 token
      await tokenService.saveToken(token);
      return token;
    }
    throw Exception('登录失败');
  }

  @override
  Future<void> logout() async {
    await apiClient.post('/auth/logout');
    await tokenService.clearToken();
  }
}
