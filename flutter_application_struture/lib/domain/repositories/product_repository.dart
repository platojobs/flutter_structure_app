// lib/domain/repositories/product_repository.dart
import 'package:flutter_application_struture/domain/entities/product_entity.dart';

/// 产品仓库接口
abstract class ProductRepository {
  /// 获取产品列表
  Future<PaginatedProducts> getProducts({
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  });

  /// 根据ID获取产品详情
  Future<ProductEntity?> getProductById(String id);

  /// 搜索产品
  Future<PaginatedProducts> searchProducts(
    String query, {
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  });

  /// 获取推荐产品
  Future<List<ProductEntity>> getRecommendedProducts({
    String? userId,
    int limit = 10,
  });

  /// 获取热门产品
  Future<List<ProductEntity>> getPopularProducts({
    ProductCategory? category,
    int limit = 10,
  });

  /// 获取新品
  Future<List<ProductEntity>> getNewProducts({
    ProductCategory? category,
    int limit = 10,
  });

  /// 获取促销产品
  Future<List<ProductEntity>> getOnSaleProducts({
    int limit = 10,
  });

  /// 获取分类产品
  Future<List<ProductEntity>> getProductsByCategory(
    ProductCategory category, {
    int page = 1,
    int limit = 20,
    String? sortBy,
  });

  /// 获取用户收藏的产品
  Future<List<ProductEntity>> getFavoriteProducts({
    String? userId,
    int page = 1,
    int limit = 20,
  });

  /// 添加到收藏
  Future<bool> addToFavorites(String productId, {String? userId});

  /// 从收藏中移除
  Future<bool> removeFromFavorites(String productId, {String? userId});

  /// 检查是否已收藏
  Future<bool> isFavorite(String productId, {String? userId});

  /// 获取产品评价
  Future<ProductReviews> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 10,
  });

  /// 添加产品评价
  Future<bool> addProductReview(
    String productId,
    ProductReview review,
  );

  /// 获取相关产品
  Future<List<ProductEntity>> getRelatedProducts(
    String productId, {
    int limit = 6,
  });

  /// 获取最近查看的产品
  Future<List<ProductEntity>> getRecentlyViewedProducts({
    String? userId,
    int limit = 10,
  });

  /// 记录产品查看
  Future<bool> recordProductView(String productId, {String? userId});

  /// 获取产品库存
  Future<int> getProductStock(String productId);

  /// 检查产品是否可购买
  Future<bool> isProductAvailable(String productId);

  /// 获取产品变体（如颜色、尺寸等）
  Future<List<ProductVariant>> getProductVariants(String productId);

  /// 创建产品（管理员功能）
  Future<ProductEntity> createProduct(CreateProductData data);

  /// 更新产品（管理员功能）
  Future<ProductEntity> updateProduct(String id, UpdateProductData data);

  /// 删除产品（管理员功能）
  Future<bool> deleteProduct(String id);

  /// 批量更新产品状态（管理员功能）
  Future<bool> batchUpdateProductStatus(
    List<String> productIds,
    ProductStatus status,
  );

  /// 获取产品统计（管理员功能）
  Future<ProductStatistics> getProductStatistics({
    DateTime? startDate,
    DateTime? endDate,
    ProductCategory? category,
  });

  /// 同步产品数据
  Future<bool> syncProducts();

  /// 获取产品标签
  Future<List<String>> getProductTags({ProductCategory? category});

  /// 获取产品属性
  Future<List<ProductAttribute>> getProductAttributes();

  /// 获取产品价格历史
  Future<List<ProductPriceHistory>> getPriceHistory(String productId);

  /// 缓存产品数据
  Future<bool> cacheProductData(List<ProductEntity> products);

  /// 获取缓存的产品数据
  Future<List<ProductEntity>?> getCachedProductData();

  /// 清除产品缓存
  Future<bool> clearProductCache();
}

// ProductFilter 已在 product_entity.dart 中定义，这里不再重复定义
// 如果需要扩展功能，可以在 repository 中创建扩展类

/// 分页产品结果
class PaginatedProducts {
  final List<ProductEntity> products;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedProducts({
    required this.products,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
  bool get isEmpty => products.isEmpty;

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    return PaginatedProducts(
      products: (json['products'] as List<dynamic>)
          .map((item) => ProductEntity.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}

/// 产品评价
class ProductReview {
  final String id;
  final String productId;
  final String userId;
  final String? userName;
  final String? userAvatar;
  final int rating;
  final String? comment;
  final List<String>? images;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int helpfulCount;
  final bool isVerifiedPurchase;

  const ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    this.userName,
    this.userAvatar,
    required this.rating,
    this.comment,
    this.images,
    required this.createdAt,
    this.updatedAt,
    this.helpfulCount = 0,
    this.isVerifiedPurchase = false,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      images: json['images'] != null 
        ? (json['images'] as List<dynamic>).cast<String>() 
        : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'helpfulCount': helpfulCount,
      'isVerifiedPurchase': isVerifiedPurchase,
    };
  }
}

/// 产品评价结果
class ProductReviews {
  final List<ProductReview> reviews;
  final double averageRating;
  final Map<int, int> ratingDistribution; // rating -> count
  final int total;
  final int page;
  final int limit;

  const ProductReviews({
    required this.reviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory ProductReviews.fromJson(Map<String, dynamic> json) {
    return ProductReviews(
      reviews: (json['reviews'] as List<dynamic>)
          .map((item) => ProductReview.fromJson(item as Map<String, dynamic>))
          .toList(),
      averageRating: (json['averageRating'] as num).toDouble(),
      ratingDistribution: Map<int, int>.from(
        (json['ratingDistribution'] as Map<dynamic, dynamic>).map(
          (key, value) => MapEntry(int.parse(key.toString()), value as int),
        ),
      ),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
    );
  }
}

/// 产品变体
class ProductVariant {
  final String id;
  final String name; // 如 '颜色', '尺寸'
  final String value; // 如 '红色', 'M'
  final double? price;
  final int? stockQuantity;
  final String? imageUrl;

  const ProductVariant({
    required this.id,
    required this.name,
    required this.value,
    this.price,
    this.stockQuantity,
    this.imageUrl,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
      price: (json['price'] as num?)?.toDouble(),
      stockQuantity: json['stockQuantity'] as int?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'price': price,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl,
    };
  }
}

/// 创建产品数据
class CreateProductData {
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? imageUrl;
  final List<String>? imageUrls;
  final ProductCategory category;
  final int stockQuantity;
  final List<String>? tags;
  final Map<String, dynamic>? specifications;

  const CreateProductData({
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.imageUrls,
    required this.category,
    this.stockQuantity = 0,
    this.tags,
    this.specifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'category': category.toString(),
      'stockQuantity': stockQuantity,
      'tags': tags,
      'specifications': specifications,
    };
  }
}

/// 更新产品数据
class UpdateProductData {
  final String? name;
  final String? description;
  final double? price;
  final double? originalPrice;
  final String? imageUrl;
  final List<String>? imageUrls;
  final ProductCategory? category;
  final int? stockQuantity;
  final ProductStatus? status;
  final List<String>? tags;
  final Map<String, dynamic>? specifications;

  const UpdateProductData({
    this.name,
    this.description,
    this.price,
    this.originalPrice,
    this.imageUrl,
    this.imageUrls,
    this.category,
    this.stockQuantity,
    this.status,
    this.tags,
    this.specifications,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (originalPrice != null) data['originalPrice'] = originalPrice;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (imageUrls != null) data['imageUrls'] = imageUrls;
    if (category != null) data['category'] = category!.toString();
    if (stockQuantity != null) data['stockQuantity'] = stockQuantity;
    if (status != null) data['status'] = status!.toString();
    if (tags != null) data['tags'] = tags;
    if (specifications != null) data['specifications'] = specifications;
    return data;
  }
}

/// 产品统计
class ProductStatistics {
  final int totalProducts;
  final int activeProducts;
  final int outOfStockProducts;
  final double averagePrice;
  final Map<ProductCategory, int> productsByCategory;
  final Map<String, int> topSellingProducts;
  final double totalSalesValue;
  final int totalSalesCount;

  const ProductStatistics({
    required this.totalProducts,
    required this.activeProducts,
    required this.outOfStockProducts,
    required this.averagePrice,
    required this.productsByCategory,
    required this.topSellingProducts,
    required this.totalSalesValue,
    required this.totalSalesCount,
  });

  factory ProductStatistics.fromJson(Map<String, dynamic> json) {
    return ProductStatistics(
      totalProducts: json['totalProducts'] as int,
      activeProducts: json['activeProducts'] as int,
      outOfStockProducts: json['outOfStockProducts'] as int,
      averagePrice: (json['averagePrice'] as num).toDouble(),
      productsByCategory: Map<ProductCategory, int>.from(
        (json['productsByCategory'] as Map<dynamic, dynamic>).map(
          (key, value) => MapEntry(
            ProductCategory.fromString(key.toString()),
            value as int,
          ),
        ),
      ),
      topSellingProducts: Map<String, int>.from(json['topSellingProducts'] as Map),
      totalSalesValue: (json['totalSalesValue'] as num).toDouble(),
      totalSalesCount: json['totalSalesCount'] as int,
    );
  }
}

/// 产品属性
class ProductAttribute {
  final String id;
  final String name;
  final List<String> values;
  final bool isRequired;
  final bool isFilterable;

  const ProductAttribute({
    required this.id,
    required this.name,
    required this.values,
    this.isRequired = false,
    this.isFilterable = true,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      id: json['id'] as String,
      name: json['name'] as String,
      values: (json['values'] as List<dynamic>).cast<String>(),
      isRequired: json['isRequired'] as bool? ?? false,
      isFilterable: json['isFilterable'] as bool? ?? true,
    );
  }
}

/// 产品价格历史
class ProductPriceHistory {
  final String id;
  final String productId;
  final double oldPrice;
  final double newPrice;
  final DateTime changedAt;
  final String? reason;

  const ProductPriceHistory({
    required this.id,
    required this.productId,
    required this.oldPrice,
    required this.newPrice,
    required this.changedAt,
    this.reason,
  });

  factory ProductPriceHistory.fromJson(Map<String, dynamic> json) {
    return ProductPriceHistory(
      id: json['id'] as String,
      productId: json['productId'] as String,
      oldPrice: (json['oldPrice'] as num).toDouble(),
      newPrice: (json['newPrice'] as num).toDouble(),
      changedAt: DateTime.parse(json['changedAt'] as String),
      reason: json['reason'] as String?,
    );
  }

  double get priceChange => newPrice - oldPrice;
  double get priceChangePercentage => (priceChange / oldPrice) * 100;
}