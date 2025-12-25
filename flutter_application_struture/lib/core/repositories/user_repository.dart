import 'package:flutter_application_struture/core/base/base_repository.dart';

/// 用户仓库（全局单例）
class UserRepository extends BaseRepository {
  /// 模拟用户数据
  static const Map<String, dynamic> _mockUser = {
    'id': '1',
    'name': '用户名',
    'email': 'user@example.com',
    'avatar': 'https://via.placeholder.com/150',
  };

  /// 获取当前用户
  Future<Map<String, dynamic>> getCurrentUser() async {
    // 模拟 API 调用
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockUser;
  }

  /// 更新用户信息
  Future<bool> updateUser(Map<String, dynamic> userData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 登出
  Future<bool> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
