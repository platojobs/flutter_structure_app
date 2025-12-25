import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../repositories/product_repository.dart';
import '../services/product_service.dart';
import '../services/favorite_service.dart';

/// 商品模块 Binding
class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // 注册仓库
    Get.lazyPut<ProductRepository>(() => ProductRepository());

    // 注册服务
    Get.lazyPut<ProductService>(() => ProductService());
    Get.lazyPut<FavoriteService>(() => FavoriteService());

    // 注册购物车控制器（全局单例）
    Get.put(CartController(), permanent: true);

    // 注册商品列表控制器（按需创建）
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
