import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../domain/usecases/product_usecases.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../../core/mixins/message_mixin.dart';
import '../../../core/mixins/cache_mixin.dart';

class ProductController extends GetxController 
    with LoadingMixin, MessageMixin, CacheMixin {
  // 依赖注入
  final ProductUseCases _productUseCases;
  
  // 响应式状态
  final RxList<ProductEntity> _products = <ProductEntity>[].obs;
  final RxList<ProductEntity> _featuredProducts = <ProductEntity>[].obs;
  final RxList<ProductEntity> _recommendedProducts = <ProductEntity>[].obs;
  final RxBool _hasMore = true.obs;
  final RxInt _currentPage = 1.obs;
  final RxString _currentCategory = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoadingMore = false.obs;
  
  // Getters
  List<ProductEntity> get products => _products;
  List<ProductEntity> get featuredProducts => _featuredProducts;
  List<ProductEntity> get recommendedProducts => _recommendedProducts;
  bool get hasMore => _hasMore.value;
  int get currentPage => _currentPage.value;
  String get currentCategory => _currentCategory.value;
  String get searchQuery => _searchQuery.value;
  bool get isLoadingMore => _isLoadingMore.value;
  
  ProductController({
    required ProductUseCases productUseCases,
  }) : _productUseCases = productUseCases;
  
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
      await saveCacheJsonList('featured_products', 
        result.map((p) => p.toJson()).toList());
    } catch (e) {
      // 从缓存加载
      final cached = await getCachedJsonList('featured_products');
      if (cached != null) {
        _featuredProducts.value = cached
            .map((json) => ProductEntity.fromJson(json))
            .toList();
      }
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
        category: category,
        page: page,
        pageSize: 20,
      );
      
      if (refresh || page == 1) {
        _products.value = result.products;
      } else {
        _products.addAll(result.products);
      }
      
      _hasMore.value = result.hasMore;
      _currentPage.value = page;
      
      if (category != null) {
        _currentCategory.value = category.value;
      }
      
      // 缓存产品列表
      await saveCacheJsonList('products_page_$page', 
        result.products.map((p) => p.toJson()).toList());
        
    } catch (e) {
      if (page == 1) {
        // 从缓存加载
        final cached = await getCachedJsonList('products_page_1');
        if (cached != null) {
          _products.value = cached
              .map((json) => ProductEntity.fromJson(json))
              .toList();
        }
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
        pageSize: 20,
      );
      
      _products.value = result.products;
      _hasMore.value = result.hasMore;
      _currentPage.value = 1;
      
    } catch (e) {
      showMessage('搜索失败', isError: true);
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
      await saveCacheJsonList('recommended_products', 
        result.map((p) => p.toJson()).toList());
    } catch (e) {
      // 从缓存加载
      final cached = await getCachedJsonList('recommended_products');
      if (cached != null) {
        _recommendedProducts.value = cached
            .map((json) => ProductEntity.fromJson(json))
            .toList();
      }
    }
  }
  
  // 加载更多产品
  Future<void> loadMoreProducts() async {
    if (!_hasMore.value || _isLoadingMore.value) return;
    
    final nextPage = _currentPage.value + 1;
    await loadProducts(
      category: _currentCategory.value.isNotEmpty 
          ? ProductCategory.fromValue(_currentCategory.value)
          : null,
      page: nextPage,
    );
  }
  
  // 刷新产品列表
  Future<void> refreshProducts() async {
    await loadProducts(
      category: _currentCategory.value.isNotEmpty 
          ? ProductCategory.fromValue(_currentCategory.value)
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
        await saveCacheJson('product_$productId', product.toJson());
      }
      
      return product;
    } catch (e) {
      showMessage('获取产品详情失败', isError: true);
      return null;
    }
  }
  
  // 添加到收藏
  Future<bool> addToFavorites(String productId) async {
    try {
      final result = await _productUseCases.addToFavorites(productId);
      showMessage('已添加到收藏', isError: false);
      return result;
    } catch (e) {
      showMessage('收藏失败', isError: true);
      return false;
    }
  }
  
  // 从收藏中移除
  Future<bool> removeFromFavorites(String productId) async {
    try {
      final result = await _productUseCases.removeFromFavorites(productId);
      showMessage('已从收藏中移除', isError: false);
      return result;
    } catch (e) {
      showMessage('移除收藏失败', isError: true);
      return false;
    }
  }
  
  // 获取产品分类
  List<ProductCategory> getProductCategories() {
    return ProductCategory.values;
  }
}