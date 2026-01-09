import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      // 登录控制器
      Bind.lazyPut<LoginController>(() => LoginController(
        authUseCases: Get.find(),
      )),
    ];
  }
}