abstract class AuthRepository {
  /// 登录，返回 token
  Future<String> login(String email, String password);

  /// 注销
  Future<void> logout();
}
