import 'package:get/instance_manager.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(
      cartUseCases: Get.find(),
    ));
  }
}