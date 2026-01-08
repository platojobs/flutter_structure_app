import 'package:flutter_application_struture/core/mixins/loading_mixin.dart';
import 'package:flutter_application_struture/core/mixins/message_mixin.dart';
import 'package:flutter_application_struture/domain/entities/product_entity.dart';
import 'package:flutter_application_struture/domain/usecases/product_usecases.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController 
    with LoadingMixin, MessageMixin {
  // 依赖注入
  final ProductUseCases _productUseCases;
  
  // 响应式状态
  final Rx<ProductEntity?> _product = Rx<ProductEntity?>(null);
  final RxList<ProductEntity> _recommendedProducts = <ProductEntity>[].obs;
  final RxInt _currentImageIndex = 0.obs;
  final RxBool _isLoading = false.obs;
  final RxString _productId = ''.obs;
  
  // Getters
  ProductEntity? get product => _product.value;
  List<ProductEntity> get recommendedProducts => _recommendedProducts;
  int get currentImageIndex => _currentImageIndex.value;
  bool get isLoading => _isLoading.value;
  String get productId => _productId.value;
  
  ProductDetailController({
    required ProductUseCases productUseCases,
    required String productId,
  }) : _productUseCases = productUseCases {
    _productId.value = productId;
  }
  
  @override
  void onInit() {
    super.onInit();
    _loadProduct();
    _loadRecommendedProducts();
  }
  
  // 加载商品详情
  Future<void> _loadProduct() async {
    try {
      setLoading(true);
      final product = await _productUseCases.getProductById(_productId.value);
      _product.value = product;
      
      // 更新缓存
      await _saveProductToCache(product!);
      
    } catch (e) {
      // 从缓存加载
      final cachedProduct = await _getProductFromCache(_productId.value);
      if (cachedProduct != null) {
        _product.value = cachedProduct;
      } else {
        showError('加载商品详情失败');
      }
    } finally {
      setLoading(false);
    }
  }
  
  // 加载推荐商品
  Future<void> _loadRecommendedProducts() async {
    try {
      final products = await _productUseCases.getRecommendedProducts();
      _recommendedProducts.value = products;
      
      // 缓存推荐商品
      await _saveRecommendedProductsToCache(products);
    } catch (e) {
      // 从缓存加载
      final cachedProducts = await _getRecommendedProductsFromCache();
      if (cachedProducts != null) {
        _recommendedProducts.value = cachedProducts;
      }
    }
  }
  
  // 设置当前图片索引
  void setCurrentImageIndex(int index) {
    _currentImageIndex.value = index;
  }
  
  // 刷新数据
  Future<void> refreshData() async {
    await _loadProduct();
    await _loadRecommendedProducts();
  }
  
  // 切换收藏状态
  Future<void> toggleFavorite() async {
    if (_product.value == null) return;
    
    try {
      final product = _product.value!;
      final isFavorite = !product.isFavorite;
      
      // 先更新UI
      _product.value = product.copyWith(isFavorite: isFavorite);
      
      // 调用服务
      await _productUseCases.toggleFavorite(product.id);
      
      // showMessage(isFavorite ? '已添加到收藏' : '已从收藏中移除');
      
    } catch (e) {
      // 恢复状态
      if (_product.value != null) {
        _product.value = _product.value!.copyWith(
          isFavorite: !_product.value!.isFavorite,
        );
      }
      // showMessage('操作失败', isError: true);
    }
  }
  
  // 分享商品
  Future<void> shareProduct() async {
    if (_product.value == null) return;
    
    try {
      // 实际实现中可以调用分享插件
      // showMessage('分享功能开发中');
    } catch (e) {
      // showMessage('分享失败', isError: true);
    }
  }
  
  // 添加到购物车
  Future<void> addToCart() async {
    if (_product.value == null) return;
    
    try {
      final product = _product.value!;
      if (!product.canPurchase) {
        // showMessage('该商品暂时无法购买', isError: true);
        return;
      }
      
      // 调用购物车服务
      await _productUseCases.addToCart(product.id, quantity: 1);
      
      // showMessage('已添加到购物车');
    } catch (e) {
      // showMessage('添加失败', isError: true);
    }
  }
  
  // 立即购买
  Future<void> buyNow() async {
    if (_product.value == null) return;
    
    final product = _product.value!;
    if (!product.canPurchase) {
      // showMessage('该商品暂时无法购买', isError: true);
      return;
    }
    
    try {
      // 导航到确认订单页面
      Get.toNamed('/order/confirm', arguments: {
        'productId': product.id,
        'quantity': 1,
      });
    } catch (e) {
      // showMessage('购买失败', isError: true);
    }
  }
  
  // 保存商品到缓存
  Future<void> _saveProductToCache(ProductEntity product) async {
    try {
      // final productJson = product.toJson();
      // 这里应该实现缓存逻辑
      // 例如使用shared_preferences或其他缓存库
    } catch (e) {
      // 忽略缓存错误
    }
  }
  
  // 从缓存获取商品
  Future<ProductEntity?> _getProductFromCache(String productId) async {
    try {
      // 这里应该实现从缓存获取逻辑
      // 返回null表示缓存中没有
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // 保存推荐商品到缓存
  Future<void> _saveRecommendedProductsToCache(List<ProductEntity> products) async {
    try {
      // final productsJson = products.map((p) => p.toJson()).toList();
      // 这里应该实现缓存逻辑
    } catch (e) {
      // 忽略缓存错误
    }
  }
  
  // 从缓存获取推荐商品
  Future<List<ProductEntity>?> _getRecommendedProductsFromCache() async {
    try {
      // 这里应该实现从缓存获取逻辑
      // 返回null表示缓存中没有
      return null;
    } catch (e) {
      return null;
    }
  }
}