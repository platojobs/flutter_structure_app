// lib/domain/repositories/auth_repository.dart
import 'package:flutter_application_struture/domain/entities/user_entity.dart';

/// 认证仓库接口
abstract class AuthRepository {
  /// 用户登录
  Future<AuthResult> login(LoginCredentials credentials);

  /// 用户注册
  Future<AuthResult> register(RegisterData data);

  /// 用户登出
  Future<bool> logout();

  /// 刷新令牌
  Future<AuthResult> refreshToken(String refreshToken);

  /// 获取当前用户信息
  Future<UserEntity?> getCurrentUser();

  /// 更新用户信息
  Future<UserEntity> updateUserProfile(UpdateUserData data);

  /// 修改密码
  Future<bool> changePassword(ChangePasswordData data);

  /// 发送重置密码邮件
  Future<bool> sendPasswordResetEmail(String email);

  /// 重置密码
  Future<bool> resetPassword(ResetPasswordData data);

  /// 检查邮箱是否已存在
  Future<bool> isEmailExists(String email);

  /// 检查手机号是否已存在
  Future<bool> isPhoneExists(String phone);

  /// 绑定第三方账号
  Future<UserEntity> bindThirdPartyAccount(ThirdPartyAccountData data);

  /// 解绑第三方账号
  Future<bool> unbindThirdPartyAccount(String provider);

  /// 获取登录历史
  Future<List<LoginHistory>> getLoginHistory({int page = 1, int limit = 10});

  /// 启用双因子认证
  Future<TwoFactorAuthResult> enableTwoFactorAuth();

  /// 验证双因子认证
  Future<bool> verifyTwoFactorAuth(String code);

  /// 禁用双因子认证
  Future<bool> disableTwoFactorAuth(String code);

  /// 获取用户权限
  Future<List<Permission>> getUserPermissions();

  /// 检查用户权限
  Future<bool> hasPermission(String permission);

  /// 获取用户角色
  Future<List<Role>> getUserRoles();

  /// 检查用户角色
  Future<bool> hasRole(String role);

  /// 保存认证状态到本地
  Future<bool> saveAuthState(AuthState authState);

  /// 从本地获取认证状态
  Future<AuthState?> getSavedAuthState();

  /// 清除本地认证状态
  Future<bool> clearAuthState();
}

/// 登录凭据
class LoginCredentials {
  final String email;
  final String password;
  final String? deviceId;
  final String? deviceInfo;
  final String? pushToken;

  const LoginCredentials({
    required this.email,
    required this.password,
    this.deviceId,
    this.deviceInfo,
    this.pushToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceId': deviceId,
      'deviceInfo': deviceInfo,
      'pushToken': pushToken,
    };
  }
}

/// 注册数据
class RegisterData {
  final String email;
  final String password;
  final String? phone;
  final String? fullName;
  final String? referralCode;
  final Map<String, dynamic>? metadata;

  const RegisterData({
    required this.email,
    required this.password,
    this.phone,
    this.fullName,
    this.referralCode,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phone': phone,
      'fullName': fullName,
      'referralCode': referralCode,
      'metadata': metadata,
    };
  }
}

/// 更新用户数据
class UpdateUserData {
  final String? fullName;
  final String? phone;
  final String? avatar;
  final Map<String, dynamic>? metadata;

  const UpdateUserData({
    this.fullName,
    this.phone,
    this.avatar,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (fullName != null) data['fullName'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (avatar != null) data['avatar'] = avatar;
    if (metadata != null) data['metadata'] = metadata;
    return data;
  }
}

/// 修改密码数据
class ChangePasswordData {
  final String currentPassword;
  final String newPassword;
  final String? verificationCode;

  const ChangePasswordData({
    required this.currentPassword,
    required this.newPassword,
    this.verificationCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'verificationCode': verificationCode,
    };
  }
}

/// 重置密码数据
class ResetPasswordData {
  final String email;
  final String verificationCode;
  final String newPassword;

  const ResetPasswordData({
    required this.email,
    required this.verificationCode,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'verificationCode': verificationCode,
      'newPassword': newPassword,
    };
  }
}

/// 第三方账号数据
class ThirdPartyAccountData {
  final String provider; // 'google', 'apple', 'facebook', 'wechat'
  final String providerId;
  final String? email;
  final String? name;
  final String? avatar;

  const ThirdPartyAccountData({
    required this.provider,
    required this.providerId,
    this.email,
    this.name,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'providerId': providerId,
      'email': email,
      'name': name,
      'avatar': avatar,
    };
  }
}

/// 认证结果
class AuthResult {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// 创建认证结果
  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  /// 转换为认证状态
  AuthState toAuthState() {
    return AuthState.authenticated(
      user: user,
      token: accessToken,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}

/// 登录历史
class LoginHistory {
  final String id;
  final DateTime loginTime;
  final String? deviceInfo;
  final String? ipAddress;
  final String? location;
  final bool isSuccessful;

  const LoginHistory({
    required this.id,
    required this.loginTime,
    this.deviceInfo,
    this.ipAddress,
    this.location,
    this.isSuccessful = true,
  });

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      id: json['id'] as String,
      loginTime: DateTime.parse(json['loginTime'] as String),
      deviceInfo: json['deviceInfo'] as String?,
      ipAddress: json['ipAddress'] as String?,
      location: json['location'] as String?,
      isSuccessful: json['isSuccessful'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginTime': loginTime.toIso8601String(),
      'deviceInfo': deviceInfo,
      'ipAddress': ipAddress,
      'location': location,
      'isSuccessful': isSuccessful,
    };
  }
}

/// 双因子认证结果
class TwoFactorAuthResult {
  final String qrCode;
  final String secret;
  final List<String> backupCodes;

  const TwoFactorAuthResult({
    required this.qrCode,
    required this.secret,
    required this.backupCodes,
  });

  factory TwoFactorAuthResult.fromJson(Map<String, dynamic> json) {
    return TwoFactorAuthResult(
      qrCode: json['qrCode'] as String,
      secret: json['secret'] as String,
      backupCodes: (json['backupCodes'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrCode': qrCode,
      'secret': secret,
      'backupCodes': backupCodes,
    };
  }
}

/// 权限
class Permission {
  final String id;
  final String name;
  final String? description;

  const Permission({
    required this.id,
    required this.name,
    this.description,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

/// 角色
class Role {
  final String id;
  final String name;
  final String? description;

  const Role({
    required this.id,
    required this.name,
    this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}