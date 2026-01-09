import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';
import 'package:flutter_application_struture/domain/usecases/product_usecases.dart';

class ProductDetailBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<ProductDetailController>(() => ProductDetailController(
        productUseCases: Get.find<ProductUseCases>(),
        productId: Get.parameters['id'] ?? '',
      )),
    ];
  }
}