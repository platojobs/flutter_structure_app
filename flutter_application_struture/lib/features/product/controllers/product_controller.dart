import 'package:flutter_application_struture/core/base/data_controller.dart';
import 'package:flutter_application_struture/core/config/controller_config.dart';
import 'package:flutter_application_struture/core/config/loading_config.dart';
import 'package:flutter_application_struture/features/product/models/product.dart';
import 'package:flutter_application_struture/features/product/repositories/product_repository.dart';
import 'package:flutter_application_struture/features/product/controllers/cart_controller.dart';
import 'package:flutter_application_struture/features/product/services/favorite_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ProductController extends DataController<Product> {
  final String? categoryId;
  final String? searchQuery;
  
  ProductController({
    this.categoryId,
    this.searchQuery,
    ControllerConfig? config,
  }) : super(config: config ?? ControllerConfig.full) {
    // 自动配置混入
    configLoading(
      loadingConfig: const LoadingConfig(
        indicatorType: EasyLoadingIndicatorType.circle,
        maskType: EasyLoadingMaskType.clear,
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }
  
  @override
  Future<List<Product>> loadData({int page = 1, int limit = 20}) async {
    final result = await safeExecute<List<Product>>(
      action: () async {
        final repository = Get.find<ProductRepository>();
        
        final products = await repository.getProducts(
          page: page,
          limit: limit,
          categoryId: categoryId,
          searchQuery: searchQuery,
          filters: filters,
          sortBy: sortBy.value,
          sortOrder: sortOrder.value,
        );
        
        return products;
      },
      loadingText: page == 1 ? '加载商品...' : null,
      showLoading: page == 1, // 只有第一页显示加载
    );

    return result ?? [];
  }
  
  /// 添加到购物车
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final confirmed = await showConfirm(
      title: '确认添加',
      message: '将 ${product.name} 添加到购物车？',
    );
    
    if (!confirmed) return;
    
    await safeExecute<void>(
      action: () async {
        final cartController = Get.find<CartController>();
        await cartController.addItem(product, quantity: quantity);
      },
      loadingText: '添加中...',
      successText: '已添加到购物车',
    );
  }
  
  /// 切换收藏状态
  Future<void> toggleFavorite(Product product) async {
    await executeSilently<void>(() async {
      final favoriteService = Get.find<FavoriteService>();
      final newFavoriteStatus = !product.isFavorite;

      // 调用 API 更新收藏状态
      await favoriteService.toggle(product.id, newFavoriteStatus);

      // 更新本地列表中的该商品
      final index = dataList.indexWhere((p) => p.id == product.id);
      if (index >= 0) {
        final updatedProduct = dataList[index].copyWith(
          isFavorite: newFavoriteStatus,
        );
        dataList[index] = updatedProduct;
        update();
      }

      // 显示提示信息
      showMessage(newFavoriteStatus ? '已收藏' : '已取消收藏');
    });
  }
  
  /// 分享商品
  Future<void> shareProduct(Product product) async {
    // 不需要加载动画的静默操作
    await executeSilently<void>(() async {
      final message = '看看这个商品: ${product.name}\n价格: ¥${product.finalPrice}';
      print('分享商品: $message');
      showMessage('已分享: ${product.name}');
    });
  }

  /// 按价格范围筛选
  void filterByPriceRange(double minPrice, double maxPrice) {
    filters['minPrice'] = minPrice;
    filters['maxPrice'] = maxPrice;
    refreshData();
  }

  /// 按评分筛选
  void filterByRating(double minRating) {
    filters['minRating'] = minRating;
    refreshData();
  }

  /// 获取商品详情
  Future<Product?> getProductDetail(String productId) async {
    final repository = Get.find<ProductRepository>();
    return await repository.getProductDetail(productId);
  }

  /// 开启选择模式
  void enableSelectMode() {
    isSelectMode.value = true;
  }

  /// 关闭选择模式
  void disableSelectMode() {
    isSelectMode.value = false;
    selectedItems.clear();
  }
}
