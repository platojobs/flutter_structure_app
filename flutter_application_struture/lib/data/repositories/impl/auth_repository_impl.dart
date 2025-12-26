import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../datasources/local/local_data_source.dart';
import '../datasources/remote/remote_data_source.dart';
import '../datasources/cache/cache_data_source.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/utils/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final CacheDataSource _cacheDataSource;
  
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userCacheKey = 'current_user';
  static const String _authStateKey = 'auth_state';

  AuthRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
    required CacheDataSource cacheDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _cacheDataSource = cacheDataSource;

  @override
  Future<AuthResult> login(LoginCredentials credentials) async {
    try {
      AppLogger.info('开始登录流程');
      
      final response = await _remoteDataSource.post(
        '/auth/login',
        data: {
          'email': credentials.email,
          'password': credentials.password,
        },
      );

      final userModel = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final userEntity = userModel.toEntity();
      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;

      await _saveAuthTokens(accessToken, refreshToken);
      await _cacheDataSource.cacheObject(_userCacheKey, userModel);
      await _cacheDataSource.cacheString(_authStateKey, 'authenticated');

      _remoteDataSource.setAuthToken(accessToken);

      final authResult = AuthResult(
        user: userEntity,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      AppLogger.info('登录成功: ${userEntity.email}');
      return authResult;
    } catch (e) {
      AppLogger.error('登录失败: $e');
      rethrow;
    }
  }

  @override
  Future<AuthResult> register(RegisterData data) async {
    try {
      AppLogger.info('开始注册流程');
      
      final response = await _remoteDataSource.post(
        '/auth/register',
        data: {
          'email': data.email,
          'password': data.password,
          'fullName': data.fullName,
          'phone': data.phone,
        },
      );

      final userModel = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final userEntity = userModel.toEntity();
      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;

      await _saveAuthTokens(accessToken, refreshToken);
      await _cacheDataSource.cacheObject(_userCacheKey, userModel);
      await _cacheDataSource.cacheString(_authStateKey, 'authenticated');

      _remoteDataSource.setAuthToken(accessToken);

      final authResult = AuthResult(
        user: userEntity,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      AppLogger.info('注册成功: ${userEntity.email}');
      return authResult;
    } catch (e) {
      AppLogger.error('注册失败: $e');
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      AppLogger.info('开始登出流程');
      
      try {
        await _remoteDataSource.post('/auth/logout', data: {});
      } catch (e) {
        AppLogger.warning('服务端登出失败，继续本地登出: $e');
      }

      await _clearAuthData();
      _remoteDataSource.removeAuthToken();

      AppLogger.info('登出成功');
      return true;
    } catch (e) {
      AppLogger.error('登出失败: $e');
      return false;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final cachedUser = await _cacheDataSource.getCachedObject<UserModel>(
        _userCacheKey,
        (json) => UserModel.fromJson(json),
      );

      if (cachedUser != null) {
        return cachedUser.toEntity();
      }

      final token = await _localDataSource.getString(_authTokenKey);
      if (token == null || token.isEmpty) {
        return null;
      }

      final response = await _remoteDataSource.get('/auth/me');
      final userModel = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final userEntity = userModel.toEntity();

      await _cacheDataSource.cacheObject(_userCacheKey, userModel);
      return userEntity;
    } catch (e) {
      AppLogger.error('获取当前用户失败: $e');
      return null;
    }
  }

  @override
  Future<String> refreshToken() async {
    try {
      final refreshToken = await _localDataSource.getString(_refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        throw AuthException(message: '没有有效的刷新令牌');
      }

      final response = await _remoteDataSource.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final accessToken = response['accessToken'] as String;
      final newRefreshToken = response['refreshToken'] as String?;

      await _saveAuthTokens(accessToken, newRefreshToken ?? refreshToken);
      _remoteDataSource.setAuthToken(accessToken);

      AppLogger.info('令牌刷新成功');
      return accessToken;
    } catch (e) {
      AppLogger.error('令牌刷新失败: $e');
      await _clearAuthData();
      _remoteDataSource.removeAuthToken();
      rethrow;
    }
  }

  @override
  Future<List<String>> getUserPermissions() async {
    try {
      final response = await _remoteDataSource.get('/auth/permissions');
      final permissions = response['permissions'] as List<dynamic>;
      return permissions.map((e) => e as String).toList();
    } catch (e) {
      AppLogger.error('获取用户权限失败: $e');
      return [];
    }
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _remoteDataSource.patch('/auth/profile', data: profileData);
      final userModel = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final userEntity = userModel.toEntity();

      await _cacheDataSource.cacheObject(_userCacheKey, userModel);
      return userEntity;
    } catch (e) {
      AppLogger.error('更新用户资料失败: $e');
      rethrow;
    }
  }

  @override
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      await _remoteDataSource.patch('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

      AppLogger.info('密码修改成功');
      return true;
    } catch (e) {
      AppLogger.error('密码修改失败: $e');
      rethrow;
    }
  }

  @override
  Future<bool> resetPassword(String email) async {
    try {
      await _remoteDataSource.post('/auth/reset-password', data: {
        'email': email,
      });

      AppLogger.info('密码重置邮件已发送: $email');
      return true;
    } catch (e) {
      AppLogger.error('密码重置失败: $e');
      rethrow;
    }
  }

  @override
  Future<bool> verifyResetToken(String token, String newPassword) async {
    try {
      await _remoteDataSource.post('/auth/verify-reset-token', data: {
        'token': token,
        'newPassword': newPassword,
      });

      AppLogger.info('密码重置验证成功');
      return true;
    } catch (e) {
      AppLogger.error('密码重置验证失败: $e');
      rethrow;
    }
  }

  @override
  Future<bool> saveAuthState(AuthState authState) async {
    try {
      final stateJson = {
        'isAuthenticated': authState.isAuthenticated,
        'user': authState.user?.toJson(),
        'accessToken': authState.accessToken,
        'refreshToken': authState.refreshToken,
      };

      await _cacheDataSource.cacheJson(_authStateKey, stateJson);
      return true;
    } catch (e) {
      AppLogger.error('保存认证状态失败: $e');
      return false;
    }
  }

  @override
  Future<AuthState?> getAuthState() async {
    try {
      final stateJson = await _cacheDataSource.getCachedJson(_authStateKey);
      if (stateJson == null) return null;

      final isAuthenticated = stateJson['isAuthenticated'] as bool? ?? false;
      if (!isAuthenticated) return AuthState(isAuthenticated: false);

      final userJson = stateJson['user'] as Map<String, dynamic>?;
      final user = userJson != null 
          ? UserEntity.fromJson(userJson)
          : null;

      final accessToken = stateJson['accessToken'] as String?;
      final refreshToken = stateJson['refreshToken'] as String?;

      return AuthState(
        isAuthenticated: isAuthenticated,
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      AppLogger.error('获取认证状态失败: $e');
      return null;
    }
  }

  @override
  Future<bool> clearAuthState() async {
    try {
      await _clearAuthData();
      return true;
    } catch (e) {
      AppLogger.error('清除认证状态失败: $e');
      return false;
    }
  }

  Future<void> _saveAuthTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      _localDataSource.setString(_authTokenKey, accessToken),
      _localDataSource.setString(_refreshTokenKey, refreshToken),
    ]);
  }

  Future<void> _clearAuthData() async {
    await Future.wait([
      _localDataSource.remove(_authTokenKey),
      _localDataSource.remove(_refreshTokenKey),
      _cacheDataSource.removeCache(_userCacheKey),
      _cacheDataSource.removeCache(_authStateKey),
    ]);
  }
}

extension UserModelExtension on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      avatar: avatar,
      phone: phone,
      status: UserStatus.values.firstWhere(
        (status) => status.value == this.status,
        orElse: () => UserStatus.inactive,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata,
    );
  }
}