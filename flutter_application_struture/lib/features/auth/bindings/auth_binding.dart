import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/login_controller.dart';

class AuthBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      // 认证控制器
      Bind.lazyPut<AuthController>(() => AuthController(
        authUseCases: Get.find(),
      )),
      
      // 登录控制器（如果需要独立管理）
      Bind.lazyPut<LoginController>(() => LoginController(
        authUseCases: Get.find(),
      )),
    ];
  }
}