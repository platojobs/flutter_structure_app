// lib/domain/usecases/auth_usecases.dart
import 'package:flutter_application_struture/domain/entities/user_entity.dart';
import 'package:flutter_application_struture/domain/repositories/auth_repository.dart';

/// 认证相关用例
abstract class AuthUseCases {
  /// 用户登录
  Future<AuthResult> login(String email, String password);

  /// 用户注册
  Future<AuthResult> register(RegisterData registerData);

  /// 用户登出
  Future<bool> logout();

  /// 刷新令牌
  Future<AuthResult> refreshToken();

  /// 获取当前用户
  Future<UserEntity?> getCurrentUser();

  /// 更新用户资料
  Future<UserEntity> updateProfile(UpdateUserData data);

  /// 修改密码
  Future<bool> changePassword(String currentPassword, String newPassword);

  /// 重置密码
  Future<bool> resetPassword(String email, String verificationCode, String newPassword);

  /// 发送重置密码邮件
  Future<bool> sendPasswordResetEmail(String email);

  /// 检查认证状态
  AuthState checkAuthState();

  /// 检查是否已认证
  bool isAuthenticated();

  /// 检查令牌是否过期
  bool isTokenExpired();
}

/// 认证用例实现
class AuthUseCasesImpl implements AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCasesImpl(this._authRepository);

  @override
  Future<AuthResult> login(String email, String password) async {
    // 验证输入参数
    if (email.isEmpty || password.isEmpty) {
      throw Exception('邮箱和密码不能为空');
    }

    // 创建登录凭据
    final credentials = LoginCredentials(
      email: email,
      password: password,
    );

    // 执行登录
    final result = await _authRepository.login(credentials);

    // 保存认证状态
    await _authRepository.saveAuthState(result.toAuthState());

    return result;
  }

  @override
  Future<AuthResult> register(RegisterData registerData) async {
    // 验证注册数据
    if (registerData.email.isEmpty || registerData.password.isEmpty) {
      throw Exception('邮箱和密码不能为空');
    }

    if (registerData.password.length < 6) {
      throw Exception('密码长度不能少于6位');
    }

    // 检查邮箱是否已存在
    final emailExists = await _authRepository.isEmailExists(registerData.email);
    if (emailExists) {
      throw Exception('该邮箱已被注册');
    }

    // 检查手机号是否已存在
    if (registerData.phone != null) {
      final phoneExists = await _authRepository.isPhoneExists(registerData.phone!);
      if (phoneExists) {
        throw Exception('该手机号已被注册');
      }
    }

    // 执行注册
    final result = await _authRepository.register(registerData);

    // 保存认证状态
    await _authRepository.saveAuthState(result.toAuthState());

    return result;
  }

  @override
  Future<bool> logout() async {
    // 清除本地认证状态
    await _authRepository.clearAuthState();

    // 通知服务器登出
    return await _authRepository.logout();
  }

  @override
  Future<AuthResult> refreshToken() async {
    // 获取保存的认证状态
    final savedAuthState = await _authRepository.getSavedAuthState();
    
    if (savedAuthState == null || savedAuthState.refreshToken == null) {
      throw Exception('没有有效的刷新令牌');
    }

    // 刷新令牌
    final result = await _authRepository.refreshToken(savedAuthState.refreshToken!);

    // 保存新的认证状态
    await _authRepository.saveAuthState(result.toAuthState());

    return result;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // 先检查本地认证状态
    final savedAuthState = await _authRepository.getSavedAuthState();
    
    if (savedAuthState == null || !savedAuthState.isAuthenticated) {
      return null;
    }

    // 检查令牌是否过期
    if (savedAuthState.isTokenExpired) {
      try {
        // 尝试刷新令牌
        await refreshToken();
      } catch (e) {
        // 刷新失败，清除认证状态
        await _authRepository.clearAuthState();
        return null;
      }
    }

    // 从服务器获取最新用户信息
    return await _authRepository.getCurrentUser();
  }

  @override
  Future<UserEntity> updateProfile(UpdateUserData data) async {
    // 验证是否已认证
    if (!await isAuthenticated()) {
      throw Exception('用户未认证');
    }

    // 更新用户信息
    final updatedUser = await _authRepository.updateUserProfile(data);

    // 更新本地认证状态
    final savedAuthState = await _authRepository.getSavedAuthState();
    if (savedAuthState != null) {
      await _authRepository.saveAuthState(
        savedAuthState.copyWith(user: updatedUser),
      );
    }

    return updatedUser;
  }

  @override
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    // 验证是否已认证
    if (!await isAuthenticated()) {
      throw Exception('用户未认证');
    }

    // 验证密码
    if (newPassword.length < 6) {
      throw Exception('新密码长度不能少于6位');
    }

    if (currentPassword == newPassword) {
      throw Exception('新密码不能与当前密码相同');
    }

    // 创建修改密码数据
    final changePasswordData = ChangePasswordData(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return await _authRepository.changePassword(changePasswordData);
  }

  @override
  Future<bool> resetPassword(String email, String verificationCode, String newPassword) async {
    // 验证参数
    if (email.isEmpty || verificationCode.isEmpty || newPassword.isEmpty) {
      throw Exception('邮箱、验证码和新密码不能为空');
    }

    if (newPassword.length < 6) {
      throw Exception('新密码长度不能少于6位');
    }

    // 创建重置密码数据
    final resetPasswordData = ResetPasswordData(
      email: email,
      verificationCode: verificationCode,
      newPassword: newPassword,
    );

    return await _authRepository.resetPassword(resetPasswordData);
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    // 验证邮箱格式
    if (email.isEmpty) {
      throw Exception('邮箱不能为空');
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      throw Exception('请输入有效的邮箱地址');
    }

    return await _authRepository.sendPasswordResetEmail(email);
  }

  @override
  AuthState checkAuthState() {
    // 同步检查认证状态
    // 这里应该从内存中获取状态，而不是异步操作
    // 实际实现中需要在应用启动时加载认证状态
    throw UnimplementedError('checkAuthState should be implemented with cached state');
  }

  @override
  bool isAuthenticated() {
    // 同步检查认证状态
    // 实际实现中需要检查内存中的认证状态
    throw UnimplementedError('isAuthenticated should be implemented with cached state');
  }

  @override
  bool isTokenExpired() {
    // 同步检查令牌过期状态
    throw UnimplementedError('isTokenExpired should be implemented with cached state');
  }
}

/// 扩展 AuthState 类，添加 copyWith 方法
extension AuthStateExtension on AuthState {
  AuthState copyWith({
    bool? isAuthenticated,
    UserEntity? user,
    String? token,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}