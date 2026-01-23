import 'package:flutter_application_struture/data/datasources/cache/cache_manager.dart';
import 'package:flutter_application_struture/data/datasources/remote/remote_data_source.dart';
import 'package:flutter_application_struture/domain/entities/product_entity.dart';
import 'package:flutter_application_struture/domain/repositories/product_repository.dart';

/// 产品仓库实现
class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource _remoteDataSource;
  final CacheManager _cacheManager;

  ProductRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required CacheManager cacheManager,
  }) : _remoteDataSource = remoteDataSource,
       _cacheManager = cacheManager;

  @override
  Future<PaginatedProducts> getProducts({
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (filter?.category != null) 'category': filter!.category.toString(),
      if (filter?.priceMin != null) 'priceMin': filter!.priceMin,
      if (filter?.priceMax != null) 'priceMax': filter!.priceMax,
      if (filter?.status != null) 'status': filter!.status.toString(),
      if (filter?.inStock != null) 'inStock': filter!.inStock,
    };

    final response = await _remoteDataSource.get('/products', queryParameters: queryParameters);
    return PaginatedProducts.fromJson(response);
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    try {
      final response = await _remoteDataSource.get('/products/$id');
      final productJson = response['product'] as Map<String, dynamic>;
      return ProductEntity.fromJson(productJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PaginatedProducts> searchProducts(
    String query, {
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParameters = <String, dynamic>{
      'query': query,
      'page': page,
      'limit': limit,
      if (filter?.category != null) 'category': filter!.category.toString(),
      if (filter?.priceMin != null) 'priceMin': filter!.priceMin,
      if (filter?.priceMax != null) 'priceMax': filter!.priceMax,
    };

    final response = await _remoteDataSource.get('/products/search', queryParameters: queryParameters);
    return PaginatedProducts.fromJson(response);
  }

  @override
  Future<List<ProductEntity>> getRecommendedProducts({
    String? userId,
    int limit = 10,
  }) async {
    final queryParameters = <String, dynamic>{'limit': limit};
    final response = await _remoteDataSource.get('/products/recommended', queryParameters: queryParameters);
    final productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductEntity>> getPopularProducts({
    ProductCategory? category,
    int limit = 10,
  }) async {
    final queryParameters = <String, dynamic>{
      'limit': limit,
      if (category != null) 'category': category.toString(),
    };
    final response = await _remoteDataSource.get('/products/popular', queryParameters: queryParameters);
    final productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductEntity>> getNewProducts({
    ProductCategory? category,
    int limit = 10,
  }) async {
    final queryParameters = <String, dynamic>{
      'limit': limit,
      if (category != null) 'category': category.toString(),
    };
    final response = await _remoteDataSource.get('/products/new', queryParameters: queryParameters);
    final productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductEntity>> getOnSaleProducts({
    int limit = 10,
  }) async {
    final queryParameters = <String, dynamic>{'limit': limit};
    final response = await _remoteDataSource.get('/products/on-sale', queryParameters: queryParameters);
    final productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(
    ProductCategory category,
    {int page = 1, int limit = 20, String? sortBy}
  ) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (sortBy != null) 'sortBy': sortBy,
    };
    final response = await _remoteDataSource.get('/products/category/${category.toString()}', queryParameters: queryParameters);
    final productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductEntity>> getFavoriteProducts({
    String? userId,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParameters = <String, dynamic>{'page': page, 'limit': limit};
    final response = await _remoteDataSource.get('/products/favorites', queryParameters: queryParameters);
    final productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> addToFavorites(String productId, {String? userId}) async {
    try {
      await _remoteDataSource.post('/products/favorites', data: {'productId': productId});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeFromFavorites(String productId, {String? userId}) async {
    try {
      await _remoteDataSource.delete('/products/favorites/$productId');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isFavorite(String productId, {String? userId}) async {
    try {
      final response = await _remoteDataSource.get('/products/favorites/check', queryParameters: {'productId': productId});
      return response['isFavorite'] as bool;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ProductReviews> getProductReviews(
    String productId,
    {int page = 1, int limit = 10}
  ) async {
    final queryParameters = <String, dynamic>{'page': page, 'limit': limit};
    final response = await _remoteDataSource.get('/products/$productId/reviews', queryParameters: queryParameters);
    return ProductReviews.fromJson(response);
  }

  @override
  Future<bool> addProductReview(String productId, ProductReview review) async {
    try {
      await _remoteDataSource.post('/products/$productId/reviews', data: review.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProductEntity>> getRelatedProducts(
    String productId,
    {int limit = 6}
  ) async {
    final queryParameters = <String, dynamic>{'limit': limit};
    final response = await _remoteDataSource.get('/products/$productId/related', queryParameters: queryParameters);
    final productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductEntity>> getRecentlyViewedProducts({
    String? userId,
    int limit = 10,
  }) async {
    final queryParameters = <String, dynamic>{'limit': limit};
    final response = await _remoteDataSource.get('/products/recently-viewed', queryParameters: queryParameters);
    final productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> recordProductView(String productId, {String? userId}) async {
    try {
      await _remoteDataSource.post('/products/$productId/view', data: {});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getProductStock(String productId) async {
    try {
      final response = await _remoteDataSource.get('/products/$productId/stock');
      return response['stock'] as int;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<bool> isProductAvailable(String productId) async {
    try {
      final response = await _remoteDataSource.get('/products/$productId/availability');
      return response['available'] as bool;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProductVariant>> getProductVariants(String productId) async {
    try {
      final response = await _remoteDataSource.get('/products/$productId/variants');
      final variantsJson = response['variants'] as List<dynamic>;
      return variantsJson
          .map((json) => ProductVariant.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ProductEntity> createProduct(CreateProductData data) async {
    final response = await _remoteDataSource.post('/products', data: data.toJson());
    return ProductEntity.fromJson(response['product'] as Map<String, dynamic>);
  }

  @override
  Future<ProductEntity> updateProduct(String id, UpdateProductData data) async {
    final response = await _remoteDataSource.put('/products/$id', data: data.toJson());
    return ProductEntity.fromJson(response['product'] as Map<String, dynamic>);
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      await _remoteDataSource.delete('/products/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> batchUpdateProductStatus(
    List<String> productIds,
    ProductStatus status,
  ) async {
    try {
      await _remoteDataSource.patch('/products/status', data: {
        'productIds': productIds,
        'status': status.toString(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ProductStatistics> getProductStatistics({
    DateTime? startDate,
    DateTime? endDate,
    ProductCategory? category,
  }) async {
    final queryParameters = <String, dynamic>{
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
      if (category != null) 'category': category.toString(),
    };
    final response = await _remoteDataSource.get('/products/statistics', queryParameters: queryParameters);
    return ProductStatistics.fromJson(response);
  }

  @override
  Future<bool> syncProducts() async {
    try {
      await _remoteDataSource.post('/products/sync', data: {});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> getProductTags({ProductCategory? category}) async {
    final queryParameters = <String, dynamic>{
      if (category != null) 'category': category.toString(),
    };
    final response = await _remoteDataSource.get('/products/tags', queryParameters: queryParameters);
    return (response['tags'] as List<dynamic>).cast<String>();
  }

  @override
  Future<List<ProductAttribute>> getProductAttributes() async {
    final response = await _remoteDataSource.get('/products/attributes');
    final attributesJson = response['attributes'] as List<dynamic>;
    return attributesJson
        .map((json) => ProductAttribute.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductPriceHistory>> getPriceHistory(String productId) async {
    try {
      final response = await _remoteDataSource.get('/products/$productId/price-history');
      final historyJson = response['history'] as List<dynamic>;
      return historyJson
          .map((json) => ProductPriceHistory.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> cacheProductData(List<ProductEntity> products) async {
    // 这里可以实现产品数据的缓存逻辑
    // 由于CacheManager目前没有提供通用的产品缓存方法，暂时返回true
    return true;
  }

  @override
  Future<List<ProductEntity>?> getCachedProductData() async {
    // 这里可以实现从缓存获取产品数据的逻辑
    // 由于CacheManager目前没有提供通用的产品缓存方法，暂时返回null
    return null;
  }

  @override
  Future<bool> clearProductCache() async {
    // 这里可以实现清除产品缓存的逻辑
    // 由于CacheManager目前没有提供通用的产品缓存方法，暂时返回true
    return true;
  }
}
