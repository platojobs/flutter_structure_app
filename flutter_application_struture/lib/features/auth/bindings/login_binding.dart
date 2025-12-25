import 'package:flutter_application_struture/features/auth/repositories/auth_repository.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    final getIt = GetIt.instance;
    final repo = getIt<AuthRepository>();
    Get.lazyPut<LoginController>(() => LoginController(repo));
  }
}
