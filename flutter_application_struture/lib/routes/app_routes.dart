class AppRoutes {
  AppRoutes._();

  // 根路径
  static const String initial = '/';

  // 认证模块
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // 产品模块
  static const String products = '/products';
  static const String productDetail = '/product-detail';
  static const String productList = '/product-list';
  static const String productSearch = '/product-search';
  static const String productCategory = '/product-category';

  // 仪表盘模块
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  // 购物车模块
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';

  // 订单模块
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String orderHistory = '/order-history';

  // 用户模块
  static const String userProfile = '/user-profile';
  static const String userSettings = '/user-settings';
  static const String userPreferences = '/user-preferences';

  // 通用页面
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String maintenance = '/maintenance';
  static const String error404 = '/404';
  static const String error500 = '/500';

  // 权限相关
  static const String unauthorized = '/unauthorized';
  static const String accessDenied = '/access-denied';
  static const String updateRequired = '/update-required';
}