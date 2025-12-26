import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:dio/dio.dart';
import '../core/config/environment.dart';
import '../domain/entities/user_entity.dart';
import 'app_routes.dart';

class RouteGuard {
  // 认证守卫 - 检查用户是否已登录
  static AuthGuard authGuard() => AuthGuard();
  
  // 权限守卫 - 检查用户权限
  static PermissionGuard permissionGuard({List<String>? requiredRoles}) => 
      PermissionGuard(requiredRoles: requiredRoles);
  
  // 环境守卫 - 检查运行环境
  static EnvironmentGuard environmentGuard() => EnvironmentGuard();
  
  // 版本守卫 - 检查应用版本
  static VersionGuard versionGuard() => VersionGuard();
}

class AuthGuard extends Middleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    // 检查用户是否已登录
    final authController = Get.find();
    final isAuthenticated = authController.isAuthenticated.value;
    
    // 需要认证的路由
    final protectedRoutes = [
      AppRoutes.dashboard,
      AppRoutes.profile,
      AppRoutes.settings,
      AppRoutes.cart,
      AppRoutes.checkout,
      AppRoutes.orders,
      AppRoutes.orderDetail,
      AppRoutes.userProfile,
    ];
    
    if (protectedRoutes.contains(route.route) && !isAuthenticated) {
      // 未认证用户重定向到登录页
      return RouteDecoder(
        route: AppRoutes.login,
        arguments: {'redirect': route.route},
      );
    }
    
    // 已认证用户访问登录页重定向到主页
    if (route.route == AppRoutes.login && isAuthenticated) {
      return RouteDecoder(
        route: AppRoutes.dashboard,
      );
    }
    
    return null;
  }
}

class PermissionGuard extends Middleware {
  final List<String>? requiredRoles;
  
  const PermissionGuard({this.requiredRoles});
  
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final authController = Get.find();
    final user = authController.currentUser.value;
    
    if (user == null) {
      return RouteDecoder(route: AppRoutes.unauthorized);
    }
    
    // 检查权限
    if (requiredRoles != null && requiredRoles!.isNotEmpty) {
      final hasPermission = _checkUserPermission(user, requiredRoles!);
      
      if (!hasPermission) {
        return RouteDecoder(route: AppRoutes.accessDenied);
      }
    }
    
    return null;
  }
  
  bool _checkUserPermission(UserEntity user, List<String> roles) {
    // 根据用户角色检查权限
    // 这里需要根据实际的权限系统实现
    final userRoles = user.roles ?? <String>[];
    
    for (final requiredRole in roles) {
      if (!userRoles.contains(requiredRole)) {
        return false;
      }
    }
    
    return true;
  }
}

class EnvironmentGuard extends Middleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final config = EnvironmentConfig.current;
    
    // 维护模式 - 只允许访问维护页面
    if (config.isMaintenanceMode) {
      final maintenanceRoutes = [
        AppRoutes.maintenance,
        AppRoutes.login, // 允许管理员登录
      ];
      
      if (!maintenanceRoutes.contains(route.route)) {
        return RouteDecoder(route: AppRoutes.maintenance);
      }
    }
    
    return null;
  }
}

class VersionGuard extends Middleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final config = EnvironmentConfig.current;
    
    // 检查最低版本要求
    final currentVersion = config.appVersion;
    final minimumVersion = config.minimumVersion;
    
    if (_compareVersions(currentVersion, minimumVersion) < 0) {
      return RouteDecoder(
        route: AppRoutes.updateRequired,
        arguments: {
          'current': currentVersion,
          'minimum': minimumVersion,
        },
      );
    }
    
    return null;
  }
  
  int _compareVersions(String current, String minimum) {
    final currentParts = current.split('.').map(int.parse).toList();
    final minimumParts = minimum.split('.').map(int.parse).toList();
    
    for (int i = 0; i < Math.max(currentParts.length, minimumParts.length); i++) {
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      final minimumPart = i < minimumParts.length ? minimumParts[i] : 0;
      
      if (currentPart < minimumPart) return -1;
      if (currentPart > minimumPart) return 1;
    }
    
    return 0;
  }
}

// 路由拦截器
class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加公共请求头
    final token = _getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    options.headers['X-App-Version'] = EnvironmentConfig.current.appVersion;
    options.headers['X-Platform'] = 'flutter';
    
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 处理特定错误
    switch (err.response?.statusCode) {
      case 401:
        _handleUnauthorized();
        break;
      case 403:
        _handleForbidden();
        break;
      case 500:
        _handleServerError();
        break;
    }
    
    super.onError(err, handler);
  }
  
  String? _getAuthToken() {
    try {
      final authController = Get.find();
      return authController.token.value;
    } catch (e) {
      return null;
    }
  }
  
  void _handleUnauthorized() {
    Get.offAllNamed(AppRoutes.login);
  }
  
  void _handleForbidden() {
    Get.offAllNamed(AppRoutes.accessDenied);
  }
  
  void _handleServerError() {
    Get.snackbar('错误', '服务器内部错误，请稍后重试');
  }
}