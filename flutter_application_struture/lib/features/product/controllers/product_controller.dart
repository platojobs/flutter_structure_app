import 'package:get/get.dart';
import '../../../domain/usecases/product_usecases.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../../core/mixins/message_mixin.dart';
import '../../../core/mixins/cache_mixin.dart';
import '../../../core/base/base_controller.dart';
import 'package:flutter/material.dart';

class ProductController extends BaseController<ProductEntity> 
    with LoadingMixin, MessageMixin, CacheMixin {
  // 依赖注入
  final ProductUseCases _productUseCases;
  final String? categoryId;
  
  // 响应式状态
  final RxList<ProductEntity> _products = <ProductEntity>[].obs;
  final RxList<ProductEntity> _featuredProducts = <ProductEntity>[].obs;
  final RxList<ProductEntity> _recommendedProducts = <ProductEntity>[].obs;
  final RxList<ProductEntity> _selectedItems = <ProductEntity>[].obs;
  final RxBool _hasMore = true.obs;
  final RxInt _currentPage = 1.obs;
  final RxString _currentCategory = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _isSelectMode = false.obs;
  final RxBool _canLoadMore = true.obs;
  
  // Getters
  List<ProductEntity> get products => _products;
  List<ProductEntity> get featuredProducts => _featuredProducts;
  List<ProductEntity> get recommendedProducts => _recommendedProducts;
  @override
  List<ProductEntity> get dataList => _products;
  List<ProductEntity> get selectedItems => _selectedItems;
  bool get hasMore => _hasMore.value;
  int get currentPage => _currentPage.value;
  String get currentCategory => _currentCategory.value;
  String get searchQuery => _searchQuery.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get isSelectMode => _isSelectMode.value;
  bool get canLoadMore => _canLoadMore.value;
  int get selectedCount => _selectedItems.length;
  
  ProductController({
    ProductUseCases? productUseCases,
    this.categoryId,
    super.config,
  }) : _productUseCases = productUseCases ?? Get.find();
  
  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }
  
  // 加载初始数据
  Future<void> _loadInitialData() async {
    try {
      setLoading(true);
      await Future.wait([
        loadFeaturedProducts(),
        loadProducts(),
        loadRecommendedProducts(),
      ]);
    } finally {
      setLoading(false);
    }
  }
  
  // 加载精选产品
  Future<void> loadFeaturedProducts() async {
    try {
      final result = await _productUseCases.getFeaturedProducts();
      _featuredProducts.value = result;
      
      // 缓存精选产品
      for (var product in result) {
        await cacheJson('featured_product_${product.id}', product.toJson());
      }
    } catch (e) {
      // 从缓存加载
      // 简化处理，暂时不实现
    }
  }
  
  // 加载产品列表
  Future<void> loadProducts({
    ProductCategory? category,
    int page = 1,
    bool refresh = false,
  }) async {
    try {
      if (page > 1) {
        _isLoadingMore.value = true;
      }
      
      final result = await _productUseCases.getProducts(
        filter: category != null ? ProductFilter(category: category) : null,
        page: page,
        limit: 20,
      );
      
      if (refresh || page == 1) {
        _products.value = result.products;
      } else {
        _products.addAll(result.products);
      }
      
      _hasMore.value = result.hasMore;
      _currentPage.value = page;
      
      if (category != null) {
        _currentCategory.value = category.toString();
      }
        
    } catch (e) {
      if (page == 1) {
        // 从缓存加载
        // 简化处理，暂时不实现
      }
    } finally {
      _isLoadingMore.value = false;
    }
  }
  
  // 搜索产品
  Future<void> searchProducts(String query) async {
    try {
      setLoading(true);
      _searchQuery.value = query;
      
      if (query.isEmpty) {
        _products.value = [];
        return;
      }
      
      final result = await _productUseCases.searchProducts(
        query: query,
        page: 1,
        limit: 20,
      );
      
      _products.value = result.products;
      _hasMore.value = result.hasMore;
      _currentPage.value = 1;
      
    } catch (e) {
      showError('搜索失败');
    } finally {
      setLoading(false);
    }
  }
  
  // 加载推荐产品
  Future<void> loadRecommendedProducts() async {
    try {
      final result = await _productUseCases.getRecommendedProducts();
      _recommendedProducts.value = result;
      
      // 缓存推荐产品
      for (var product in result) {
        await cacheJson('recommended_product_${product.id}', product.toJson());
      }
    } catch (e) {
      // 从缓存加载
      // 简化处理，暂时不实现
    }
  }
  
  // 加载更多产品
  Future<void> loadMoreProducts() async {
    if (!_hasMore.value || _isLoadingMore.value) return;
    
    final nextPage = _currentPage.value + 1;
    await loadProducts(
      category: _currentCategory.value.isNotEmpty 
          ? ProductCategory.fromString(_currentCategory.value)
          : null,
      page: nextPage,
    );
  }
  
  // 刷新产品列表
  Future<void> refreshProducts() async {
    await loadProducts(
      category: _currentCategory.value.isNotEmpty 
          ? ProductCategory.fromString(_currentCategory.value)
          : null,
      page: 1,
      refresh: true,
    );
  }
  
  // 按分类筛选产品
  Future<void> filterByCategory(ProductCategory category) async {
    _currentCategory.value = category.value;
    await loadProducts(
      category: category,
      page: 1,
      refresh: true,
    );
  }
  
  // 清除筛选
  void clearFilters() {
    _currentCategory.value = '';
    _searchQuery.value = '';
    refreshProducts();
  }
  
  // 获取产品详情
  Future<ProductEntity?> getProductDetail(String productId) async {
    try {
      // 先尝试从缓存获取
      final cachedProduct = await getCachedJson('product_$productId');
      if (cachedProduct != null) {
        return ProductEntity.fromJson(cachedProduct);
      }
      
      // 从网络获取
      final product = await _productUseCases.getProductById(productId);
      if (product != null) {
        // 缓存产品详情
        await cacheJson('product_$productId', product.toJson());
      }
      
      return product;
    } catch (e) {
      showError('获取产品详情失败');
      return null;
    }
  }
  
  // 添加到收藏
  Future<bool> addToFavorites(String productId) async {
    try {
      final result = await _productUseCases.addToFavorites(productId);
      showSuccess('已添加到收藏');
      return result;
    } catch (e) {
      showError('收藏失败');
      return false;
    }
  }
  
  // 从收藏中移除
  Future<bool> removeFromFavorites(String productId) async {
    try {
      final result = await _productUseCases.removeFromFavorites(productId);
      showSuccess('已从收藏中移除');
      return result;
    } catch (e) {
      showError('移除收藏失败');
      return false;
    }
  }
  
  // 获取产品分类
  List<ProductCategory> getProductCategories() {
    return ProductCategory.values;
  }
  
  // 切换选择模式
  void toggleSelectMode() {
    _isSelectMode.value = !_isSelectMode.value;
    if (!_isSelectMode.value) {
      _selectedItems.clear();
    }
  }
  
  // 切换产品选择状态
  void toggleSelection(ProductEntity product) {
    if (_selectedItems.contains(product)) {
      _selectedItems.remove(product);
    } else {
      _selectedItems.add(product);
    }
  }
  
  // 全选/取消全选
  void toggleSelectAll() {
    if (_selectedItems.length == _products.length) {
      _selectedItems.clear();
    } else {
      _selectedItems.value = [..._products];
    }
  }
  
  // 清除所有选择
  void clearSelection() {
    _selectedItems.clear();
  }
  
  // 加载更多产品
  void loadMore() {
    if (_canLoadMore.value && !_isLoadingMore.value) {
      loadMoreProducts();
    }
  }
  
  // 添加到购物车
  Future<bool> addToCart(ProductEntity product) async {
    try {
      // TODO: 实际添加到购物车的实现
      showSuccess('已添加到购物车');
      return true;
    } catch (e) {
      showError('添加失败');
      return false;
    }
  }
  
  // 切换收藏状态
  Future<bool> toggleFavorite(ProductEntity product) async {
    try {
      if (product.isFavorite) {
        return await removeFromFavorites(product.id);
      } else {
        return await addToFavorites(product.id);
      }
    } catch (e) {
      showError('操作失败');
      return false;
    }
  }
  
  // 搜索产品
  void search(String keyword) {
    searchProducts(keyword);
  }
  
  // 按价格范围筛选
  void filterByPriceRange(double minPrice, double maxPrice) {
    // TODO: 实现价格筛选逻辑
  }
  
  // 按评分筛选
  void filterByRating(double minRating) {
    // TODO: 实现评分筛选逻辑
  }
  
  // 显示确认对话框
  void showConfirm(String title, String content, VoidCallback onConfirm) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
  
  // 安全执行函数
  // 使用基类中定义的方法，不再重复定义
  
  // 刷新数据
  Future<void> refreshData() async {
    await refreshProducts();
  }
}