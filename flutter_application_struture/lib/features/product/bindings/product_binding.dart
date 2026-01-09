import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<ProductController>(() => ProductController(
        productUseCases: Get.find(),
      )),
    ];
  }
}