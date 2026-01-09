import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<CartController>(() => CartController(
        cartUseCases: Get.find(),
      )),
    ];
  }
}