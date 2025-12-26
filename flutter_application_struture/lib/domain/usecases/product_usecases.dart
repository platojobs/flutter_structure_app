import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

abstract class ProductUseCases {
  Future<PaginatedProducts> getProducts({
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  });
  
  Future<ProductEntity?> getProductById(String id);
  
  Future<PaginatedProducts> searchProducts({
    required String query,
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  });
  
  Future<List<ProductEntity>> getProductsByCategory(ProductCategory category);
  
  Future<List<ProductEntity>> getFeaturedProducts();
  
  Future<List<ProductEntity>> getRecommendedProducts();
  
  Future<List<ProductEntity>> getPopularProducts();
  
  Future<List<ProductEntity>> getDiscountedProducts();
  
  Future<bool> toggleFavorite(String productId);
  
  Future<bool> addToFavorites(String productId);
  
  Future<bool> removeFromFavorites(String productId);
  
  Future<List<ProductEntity>> getFavoriteProducts();
  
  Future<bool> isFavorite(String productId);
  
  Future<bool> addToCart(String productId, {int quantity = 1});
  
  Future<ProductReviews> getProductReviews(String productId);
  
  Future<bool> addProductReview(String productId, String comment, double rating);
}

class ProductUseCasesImpl implements ProductUseCases {
  final ProductRepository _productRepository;
  
  ProductUseCasesImpl(this._productRepository);
  
  @override
  Future<PaginatedProducts> getProducts({
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _productRepository.getProducts(
        filter: filter,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw Exception('获取产品列表失败: $e');
    }
  }
  
  @override
  Future<ProductEntity?> getProductById(String id) async {
    try {
      if (id.isEmpty) throw Exception('产品ID不能为空');
      
      return await _productRepository.getProductById(id);
    } catch (e) {
      throw Exception('获取产品详情失败: $e');
    }
  }
  
  @override
  Future<PaginatedProducts> searchProducts({
    required String query,
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (query.trim().isEmpty) {
        return const PaginatedProducts(
          products: [],
          total: 0,
          page: 1,
          limit: 20,
          totalPages: 0,
        );
      }
      
      return await _productRepository.searchProducts(
        query.trim(),
        filter: filter,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw Exception('搜索产品失败: $e');
    }
  }
  
  @override
  Future<List<ProductEntity>> getProductsByCategory(ProductCategory category) async {
    try {
      return await _productRepository.getProductsByCategory(category);
    } catch (e) {
      throw Exception('获取分类产品失败: $e');
    }
  }
  
  @override
  Future<List<ProductEntity>> getFeaturedProducts() async {
    try {
      return await _productRepository.getRecommendedProducts(limit: 10);
    } catch (e) {
      throw Exception('获取推荐产品失败: $e');
    }
  }
  
  @override
  Future<List<ProductEntity>> getRecommendedProducts() async {
    try {
      return await _productRepository.getRecommendedProducts(limit: 10);
    } catch (e) {
      throw Exception('获取推荐产品失败: $e');
    }
  }
  
  @override
  Future<List<ProductEntity>> getPopularProducts() async {
    try {
      return await _productRepository.getPopularProducts(limit: 10);
    } catch (e) {
      throw Exception('获取热门产品失败: $e');
    }
  }
  
  @override
  Future<List<ProductEntity>> getDiscountedProducts() async {
    try {
      return await _productRepository.getOnSaleProducts(limit: 10);
    } catch (e) {
      throw Exception('获取折扣产品失败: $e');
    }
  }
  
  @override
  Future<bool> toggleFavorite(String productId) async {
    try {
      if (productId.isEmpty) throw Exception('产品ID不能为空');
      
      final isFav = await _productRepository.isFavorite(productId);
      if (isFav) {
        return await _productRepository.removeFromFavorites(productId);
      } else {
        return await _productRepository.addToFavorites(productId);
      }
    } catch (e) {
      throw Exception('切换收藏状态失败: $e');
    }
  }
  
  @override
  Future<bool> addToFavorites(String productId) async {
    try {
      if (productId.isEmpty) throw Exception('产品ID不能为空');
      
      return await _productRepository.addToFavorites(productId);
    } catch (e) {
      throw Exception('添加到收藏失败: $e');
    }
  }
  
  @override
  Future<bool> removeFromFavorites(String productId) async {
    try {
      if (productId.isEmpty) throw Exception('产品ID不能为空');
      
      return await _productRepository.removeFromFavorites(productId);
    } catch (e) {
      throw Exception('从收藏中移除失败: $e');
    }
  }
  
  @override
  Future<List<ProductEntity>> getFavoriteProducts() async {
    try {
      return await _productRepository.getFavoriteProducts();
    } catch (e) {
      throw Exception('获取收藏产品失败: $e');
    }
  }
  
  @override
  Future<bool> isFavorite(String productId) async {
    try {
      if (productId.isEmpty) return false;
      
      return await _productRepository.isFavorite(productId);
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> addToCart(String productId, {int quantity = 1}) async {
    try {
      if (productId.isEmpty) throw Exception('产品ID不能为空');
      if (quantity < 1) throw Exception('数量必须大于0');
      
      // 这里应该调用购物车服务
      // 暂时返回true作为占位符
      return true;
    } catch (e) {
      throw Exception('添加到购物车失败: $e');
    }
  }
  
  @override
  Future<ProductReviews> getProductReviews(String productId) async {
    try {
      if (productId.isEmpty) throw Exception('产品ID不能为空');
      
      return await _productRepository.getProductReviews(productId);
    } catch (e) {
      throw Exception('获取产品评价失败: $e');
    }
  }
  
  @override
  Future<bool> addProductReview(String productId, String comment, double rating) async {
    try {
      if (productId.isEmpty) throw Exception('产品ID不能为空');
      if (comment.trim().isEmpty) throw Exception('评价内容不能为空');
      if (rating < 1 || rating > 5) throw Exception('评分必须在1-5之间');
      
      final review = ProductReview(
        id: '', // 实际应用中应由服务端生成
        productId: productId,
        userId: '', // 实际应用中应该从用户状态获取
        rating: rating.toInt(),
        comment: comment.trim(),
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      
      return await _productRepository.addProductReview(productId, review);
    } catch (e) {
      throw Exception('添加评价失败: $e');
    }
  }
}