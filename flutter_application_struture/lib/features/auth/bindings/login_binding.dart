import 'package:get/instance_manager.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // 登录控制器
    Get.lazyPut<LoginController>(() => LoginController(
      authUseCases: Get.find(),
    ));
  }
}