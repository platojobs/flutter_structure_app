// lib/domain/entities/user_entity.dart
/// 用户领域实体
class UserEntity {
  final String id;
  final String email;
  final String? phone;
  final String? fullName;
  final String? avatar;
  final UserStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? metadata;

  const UserEntity({
    required this.id,
    required this.email,
    this.phone,
    this.fullName,
    this.avatar,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.metadata,
  });

  /// 创建新用户
  factory UserEntity.create({
    required String email,
    String? phone,
    String? fullName,
    String? avatar,
    Map<String, dynamic>? metadata,
  }) {
    return UserEntity(
      id: '', // 实际应用中应由服务端生成
      email: email,
      phone: phone,
      fullName: fullName,
      avatar: avatar,
      status: UserStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      metadata: metadata,
    );
  }

  /// 从JSON创建用户实体
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['fullName'] as String?,
      avatar: json['avatar'] as String?,
      status: UserStatus.fromString(json['status'] as String? ?? 'active'),
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'] as String) 
        : null,
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
      lastLoginAt: json['lastLoginAt'] != null 
        ? DateTime.parse(json['lastLoginAt'] as String) 
        : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'avatar': avatar,
      'status': status.toString(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// 复制用户实体
  UserEntity copyWith({
    String? id,
    String? email,
    String? phone,
    String? fullName,
    String? avatar,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// 获取显示名称
  String get displayName => fullName ?? email.split('@').first;

  /// 是否为活跃用户
  bool get isActive => status == UserStatus.active;

  /// 是否为禁用用户
  bool get isInactive => status == UserStatus.inactive;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, email: $email, status: $status)';
}

/// 用户状态枚举
enum UserStatus {
  active('active'),
  inactive('inactive'),
  pending('pending'),
  suspended('suspended');

  const UserStatus(this.value);

  final String value;

  static UserStatus fromString(String value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserStatus.active,
    );
  }

  @override
  String toString() => value;
}

/// 用户认证状态
class AuthState {
  final bool isAuthenticated;
  final UserEntity? user;
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.token,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  /// 已认证状态
  factory AuthState.authenticated({
    required UserEntity user,
    required String token,
    String? accessToken,
    String? refreshToken,
    required DateTime expiresAt,
  }) {
    return AuthState(
      isAuthenticated: true,
      user: user,
      token: token,
      accessToken: accessToken ?? token,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  /// 未认证状态
  factory AuthState.unauthenticated() {
    return const AuthState();
  }

  /// 是否token已过期
  bool get isTokenExpired {
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// 获取剩余有效时间
  Duration? get remainingTime {
    if (expiresAt == null) return null;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState && 
      runtimeType == other.runtimeType && 
      isAuthenticated == other.isAuthenticated &&
      user == other.user &&
      token == other.token &&
      accessToken == other.accessToken &&
      refreshToken == other.refreshToken;

  @override
  int get hashCode =>
      isAuthenticated.hashCode ^ 
      user.hashCode ^ 
      token.hashCode ^ 
      accessToken.hashCode ^ 
      refreshToken.hashCode;
}