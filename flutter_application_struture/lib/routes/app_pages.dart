// lib/routes/app_pages.dart
import 'package:get/get.dart';
import '../features/auth/bindings/login_binding.dart';
import '../features/auth/views/login_page.dart';
import '../pages/home_page.dart';

class AppPages {
  static const initial = '/login';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/home',
      page: () => const HomePage(),
      transition: Transition.cupertino,
    ),
  ];
}


