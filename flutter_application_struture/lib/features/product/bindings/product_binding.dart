import 'package:get/instance_manager.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController(
      productUseCases: Get.find(),
    ));
  }
}