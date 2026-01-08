import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/auth/bindings/auth_binding.dart';
import '../features/auth/bindings/login_binding.dart';
import '../features/product/bindings/product_binding.dart';
import '../features/product/bindings/product_detail_binding.dart';
import '../features/dashboard/bindings/dashboard_binding.dart';
import '../features/cart/bindings/cart_binding.dart';
import '../features/order/bindings/order_binding.dart';
import '../features/user/bindings/user_binding.dart';
// import '../features/profile/bindings/profile_binding.dart'; // 未使用
import 'app_routes.dart';
import 'route_guards.dart';

class AppPages {
  AppPages._();

  // 初始路由
  static const String initial = AppRoutes.initial;

  // 获取所有路由
  static List<GetPage> get routes => pages;

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
      page: () => const OrderDetailPage(),
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
      page: () => InitialPage(),
      binding: InitialBinding(),
      middlewares: [
        RouteGuard.environmentGuard(),
        RouteGuard.versionGuard(),
      ],
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
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('启动页面'),
      ),
    );
  }
}
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('欢迎页面'),
      ),
    );
  }
}
class InitialPage extends StatelessWidget {
  const InitialPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('初始页面'),
      ),
    );
  }
}
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('登录页面'),
      ),
    );
  }
}
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('注册页面'),
      ),
    );
  }
}
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('忘记密码页面'),
      ),
    );
  }
}
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('重置密码页面'),
      ),
    );
  }
}
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('仪表盘页面'),
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('首页'),
      ),
    );
  }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('个人资料页面'),
      ),
    );
  }
}
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('设置页面'),
      ),
    );
  }
}
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('通知页面'),
      ),
    );
  }
}
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('产品页面'),
      ),
    );
  }
}
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('产品列表页面'),
      ),
    );
  }
}
class ProductSearchPage extends StatelessWidget {
  const ProductSearchPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('产品搜索页面'),
      ),
    );
  }
}
class ProductCategoryPage extends StatelessWidget {
  const ProductCategoryPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('产品分类页面'),
      ),
    );
  }
}
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('产品详情页面'),
      ),
    );
  }
}
class CartPage extends StatelessWidget {
  const CartPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('购物车页面'),
      ),
    );
  }
}
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('结账页面'),
      ),
    );
  }
}
class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('订单确认页面'),
      ),
    );
  }
}
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('订单页面'),
      ),
    );
  }
}
class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('订单详情页面'),
      ),
    );
  }
}
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('订单历史页面'),
      ),
    );
  }
}
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('用户资料页面'),
      ),
    );
  }
}
class Error404Page extends StatelessWidget {
  const Error404Page({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('404 页面未找到'),
      ),
    );
  }
}
class Error500Page extends StatelessWidget {
  const Error500Page({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('500 服务器错误'),
      ),
    );
  }
}
class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('未授权访问'),
      ),
    );
  }
}
class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('访问被拒绝'),
      ),
    );
  }
}
class UpdateRequiredPage extends StatelessWidget {
  const UpdateRequiredPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('需要更新应用'),
      ),
    );
  }
}
class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('系统维护中'),
      ),
    );
  }
}

// Binding 类定义
class SplashBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => SplashController()),
    ];
  }
}
class WelcomeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => WelcomeController()),
    ];
  }
}
class InitialBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => InitialController()),
    ];
  }
}
class ErrorBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => ErrorController()),
    ];
  }
}
class UpdateBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => UpdateController()),
    ];
  }
}
class MaintenanceBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => MaintenanceController()),
    ];
  }
}

// 临时控制器类定义
class SplashController extends GetxController {}
class WelcomeController extends GetxController {}
class InitialController extends GetxController {}
class ErrorController extends GetxController {}
class UpdateController extends GetxController {}
class MaintenanceController extends GetxController {}
// 重复的页面类定义已移除

// 临时控制器类定义