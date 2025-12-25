import 'package:get/get.dart';
import 'package:flutter_application_struture/core/services/token_service.dart';

/// 认证中间件 - 在路由前检查用户是否已登录
class AuthMiddleware extends GetMiddleware {
  /// 需要认证的路由列表（黑名单模式：列出的路由需要认证）
  static const protectedRoutes = ['/home', '/profile', '/settings'];

  @override
  int get priority => 1;

  @override
  GetPage? onPageCalled(GetPage? page) {
    // 检查当前路由是否需要认证
    if (_isProtectedRoute(page?.name)) {
      // 从 GetIt 获取 TokenService 检查是否已登录
      final tokenService = Get.find<TokenService>();
      
      // 如果没有 token，重定向到登录页
      if (!tokenService.hasToken) {
        Future.microtask(() => Get.offNamed('/login'));
        return null;
      }
    }
    
    // 如果已登录且要访问登录页，重定向到首页
    if (page?.name == '/login') {
      final tokenService = Get.find<TokenService>();
      if (tokenService.hasToken) {
        Future.microtask(() => Get.offNamed('/home'));
        return null;
      }
    }
    
    return super.onPageCalled(page);
  }

  /// 检查路由是否受保护
  bool _isProtectedRoute(String? route) {
    return protectedRoutes.contains(route);
  }
}

/// 简单的路由守卫类（用于其他需求）
class RouteGuard {
  /// 检查用户是否已认证
  static Future<bool> isAuthenticated() async {
    final tokenService = Get.find<TokenService>();
    return tokenService.hasToken;
  }

  /// 检查用户权限
  static Future<bool> hasPermission(String permission) async {
    // 实现权限检查逻辑
    return true;
  }
}