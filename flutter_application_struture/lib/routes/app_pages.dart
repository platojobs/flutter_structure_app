import 'package:get/get.dart';
import '../features/auth/bindings/auth_binding.dart';
import '../features/auth/bindings/login_binding.dart';
import '../features/product/bindings/product_binding.dart';
import '../features/product/bindings/product_detail_binding.dart';
import '../features/dashboard/bindings/dashboard_binding.dart';
import '../features/cart/bindings/cart_binding.dart';
import '../features/order/bindings/order_binding.dart';
import '../features/user/bindings/user_binding.dart';
import '../features/profile/bindings/profile_binding.dart';
import 'app_routes.dart';
import 'route_guards.dart';

class AppPages {
  AppPages._();

  // 初始页面 - 可以根据用户状态动态决定
  static final pages = [
    // 启动页面
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      middlewares: [
        RouteGuard.environmentGuard(),
        RouteGuard.versionGuard(),
      ],
    ),

    // 欢迎页面
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
      middlewares: [
        RouteGuard.environmentGuard(),
      ],
    ),

    // 认证模块
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordPage(),
      binding: AuthBinding(),
    ),

    // 仪表盘模块
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
      children: [
        // 仪表盘子路由
        GetPage(
          name: AppRoutes.home,
          page: () => const HomePage(),
          binding: DashboardBinding(),
        ),
        GetPage(
          name: AppRoutes.profile,
          page: () => const ProfilePage(),
          binding: UserBinding(),
        ),
        GetPage(
          name: AppRoutes.settings,
          page: () => const SettingsPage(),
          binding: UserBinding(),
        ),
        GetPage(
          name: AppRoutes.notifications,
          page: () => const NotificationsPage(),
          binding: DashboardBinding(),
        ),
      ],
    ),

    // 产品模块
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductsPage(),
      binding: ProductBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListPage(),
      binding: ProductBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.productSearch,
      page: () => const ProductSearchPage(),
      binding: ProductBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.productCategory,
      page: () => const ProductCategoryPage(),
      binding: ProductBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailPage(),
      binding: ProductDetailBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
      transition: Transition.rightToLeft,
    ),

    // 购物车模块
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartPage(),
      binding: CartBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutPage(),
      binding: CartBinding(),
      middlewares: [
        RouteGuard.authGuard(),
        RouteGuard.permissionGuard(requiredRoles: ['user', 'admin']),
      ],
    ),
    GetPage(
      name: AppRoutes.orderConfirmation,
      page: () => const OrderConfirmationPage(),
      binding: OrderBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
      transition: Transition.fadeIn,
    ),

    // 订单模块
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersPage(),
      binding: OrderBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => OrderDetailPage(),
      binding: OrderBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryPage(),
      binding: OrderBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),

    // 用户模块
    GetPage(
      name: AppRoutes.userProfile,
      page: () => const UserProfilePage(),
      binding: UserBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.userSettings,
      page: () => const UserSettingsPage(),
      binding: UserBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.userPreferences,
      page: () => const UserPreferencesPage(),
      binding: UserBinding(),
      middlewares: [
        RouteGuard.authGuard(),
      ],
    ),

    // 错误页面
    GetPage(
      name: AppRoutes.error404,
      page: () => const Error404Page(),
      binding: ErrorBinding(),
    ),
    GetPage(
      name: AppRoutes.error500,
      page: () => const Error500Page(),
      binding: ErrorBinding(),
    ),

    // 权限相关页面
    GetPage(
      name: AppRoutes.unauthorized,
      page: () => const UnauthorizedPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.accessDenied,
      page: () => const AccessDeniedPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.updateRequired,
      page: () => const UpdateRequiredPage(),
      binding: UpdateBinding(),
    ),

    // 维护模式页面
    GetPage(
      name: AppRoutes.maintenance,
      page: () => const MaintenancePage(),
      binding: MaintenanceBinding(),
      middlewares: [
        RouteGuard.environmentGuard(),
      ],
    ),

    // 默认重定向到初始页面
    GetPage(
      name: AppRoutes.initial,
      page: () => const InitialPage(),
      binding: InitialBinding(),
      middlewares: [
        RouteGuard.environmentGuard(),
        RouteGuard.versionGuard(),
      ],
      redirect: (route) {
        // 动态重定向逻辑
        final authController = Get.find();
        if (authController.isFirstLaunch.value) {
          return AppRoutes.welcome;
        }
        if (!authController.isAuthenticated.value) {
          return AppRoutes.login;
        }
        return AppRoutes.dashboard;
      },
    ),
  ];

  // 获取页面路径
  static List<GetPage> getPages() => pages;

  // 动态添加页面
  static void addPage(GetPage page) {
    pages.add(page);
  }

  // 移除页面
  static void removePage(String name) {
    pages.removeWhere((page) => page.name == name);
  }

  // 清空所有页面
  static void clearPages() {
    pages.clear();
  }

  // 重置到默认页面
  static void resetToDefault() {
    pages.clear();
    pages.addAll(pages);
  }
}

// 页面类定义（需要在对应的features模块中实现）
class SplashPage {}
class WelcomePage {}
class InitialPage {}
class LoginPage {}
class RegisterPage {}
class ForgotPasswordPage {}
class ResetPasswordPage {}
class DashboardPage {}
class HomePage {}
class ProfilePage {}
class SettingsPage {}
class NotificationsPage {}
class ProductsPage {}
class ProductListPage {}
class ProductSearchPage {}
class ProductCategoryPage {}
class ProductDetailPage {}
class CartPage {}
class CheckoutPage {}
class OrderConfirmationPage {}
class OrdersPage {}
class OrderDetailPage {}
class OrderHistoryPage {}
class UserProfilePage {}
class UserSettingsPage {}
class UserPreferencesPage {}
class Error404Page {}
class Error500Page {}
class UnauthorizedPage {}
class AccessDeniedPage {}
class UpdateRequiredPage {}
class MaintenancePage {}

// Binding类定义（需要在对应的bindings模块中实现）
class SplashBinding extends Bindings {}
class WelcomeBinding extends Bindings {}
class InitialBinding extends Bindings {}
class ErrorBinding extends Bindings {}
class UpdateBinding extends Bindings {}
class MaintenanceBinding extends Bindings {}