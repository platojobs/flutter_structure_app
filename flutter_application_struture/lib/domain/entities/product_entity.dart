// lib/domain/entities/product_entity.dart
/// 产品领域实体
class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? imageUrl;
  final List<String> imageUrls;
  final ProductCategory category;
  final ProductStatus status;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic>? specifications;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;
  final double? discount;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    required this.imageUrls,
    required this.category,
    required this.status,
    required this.stockQuantity,
    required this.rating,
    required this.reviewCount,
    this.specifications,
    required this.tags,
    this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
    this.discount,
  });

  /// 创建新产品
  factory ProductEntity.create({
    required String name,
    required String description,
    required double price,
    double? originalPrice,
    String? imageUrl,
    List<String>? imageUrls,
    required ProductCategory category,
    int stockQuantity = 0,
    List<String>? tags,
    Map<String, dynamic>? specifications,
  }) {
    return ProductEntity(
      id: '', // 实际应用中应由服务端生成
      name: name,
      description: description,
      price: price,
      originalPrice: originalPrice,
      imageUrl: imageUrl,
      imageUrls: imageUrls ?? (imageUrl != null ? [imageUrl] : []),
      category: category,
      status: ProductStatus.active,
      stockQuantity: stockQuantity,
      rating: 0.0,
      reviewCount: 0,
      tags: tags ?? [],
      specifications: specifications,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isFavorite: false,
    );
  }

  /// 从JSON创建产品实体
  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>).cast<String>(),
      category: ProductCategory.fromString(json['category'] as String? ?? 'other'),
      status: ProductStatus.fromString(json['status'] as String? ?? 'active'),
      stockQuantity: json['stockQuantity'] as int,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      specifications: json['specifications'] as Map<String, dynamic>?,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'] as String) 
        : null,
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
      isFavorite: json['isFavorite'] as bool? ?? false,
      discount: (json['discount'] as num?)?.toDouble(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'category': category.toString(),
      'status': status.toString(),
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'specifications': specifications,
      'tags': tags,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isFavorite': isFavorite,
      'discount': discount,
    };
  }

  /// 复制产品实体
  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? imageUrls,
    ProductCategory? category,
    ProductStatus? status,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
    Map<String, dynamic>? specifications,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    double? discount,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      status: status ?? this.status,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      specifications: specifications ?? this.specifications,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      discount: discount ?? this.discount,
    );
  }

  /// 获取格式化价格
  String get formattedPrice => '¥${price.toStringAsFixed(2)}';

  /// 获取格式化原价
  String? get formattedOriginalPrice => 
      originalPrice != null ? '¥${originalPrice!.toStringAsFixed(2)}' : null;

  /// 获取折扣百分比
  double? get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  /// 是否在促销
  bool get isOnSale => originalPrice != null && originalPrice! > price;

  /// 是否有库存
  bool get inStock => stockQuantity > 0;

  /// 库存状态
  StockStatus get stockStatus {
    if (stockQuantity <= 0) return StockStatus.outOfStock;
    if (stockQuantity <= 10) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  /// 是否可购买
  bool get canPurchase => status == ProductStatus.active && inStock;

  /// 获取星级评价显示
  String get ratingDisplay => '${rating.toStringAsFixed(1)} ($reviewCount评价)';

  /// 获取主要图片
  String get mainImage => imageUrl ?? (imageUrls.isNotEmpty ? imageUrls.first : '');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductEntity(id: $id, name: $name, price: $price)';
}

/// 产品分类枚举
enum ProductCategory {
  electronics('electronics'),
  clothing('clothing'),
  books('books'),
  home('home'),
  sports('sports'),
  beauty('beauty'),
  toys('toys'),
  food('food'),
  other('other');

  const ProductCategory(this.value);

  final String value;

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ProductCategory.other,
    );
  }

  @override
  String toString() => value;
}

/// 产品状态枚举
enum ProductStatus {
  active('active'),
  inactive('inactive'),
  discontinued('discontinued'),
  draft('draft');

  const ProductStatus(this.value);

  final String value;

  static ProductStatus fromString(String value) {
    return ProductStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ProductStatus.active,
    );
  }

  @override
  String toString() => value;
}

/// 库存状态枚举
enum StockStatus {
  inStock('inStock'),
  lowStock('lowStock'),
  outOfStock('outOfStock');

  const StockStatus(this.value);

  final String value;

  @override
  String toString() => value;
}

/// 产品搜索过滤器
class ProductFilter {
  final ProductCategory? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final List<String>? tags;
  final bool? inStock;
  final ProductStatus? status;
  final String? searchQuery;

  const ProductFilter({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.tags,
    this.inStock,
    this.status,
    this.searchQuery,
  });

  /// 复制过滤器
  ProductFilter copyWith({
    ProductCategory? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? tags,
    bool? inStock,
    ProductStatus? status,
    String? searchQuery,
  }) {
    return ProductFilter(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      tags: tags ?? this.tags,
      inStock: inStock ?? this.inStock,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// 转换为查询参数
  Map<String, dynamic> toQueryParameters() {
    final parameters = <String, dynamic>{};
    
    if (category != null) {
      parameters['category'] = category!.value;
    }
    if (minPrice != null) {
      parameters['minPrice'] = minPrice;
    }
    if (maxPrice != null) {
      parameters['maxPrice'] = maxPrice;
    }
    if (minRating != null) {
      parameters['minRating'] = minRating;
    }
    if (tags != null && tags!.isNotEmpty) {
      parameters['tags'] = tags!.join(',');
    }
    if (inStock != null) {
      parameters['inStock'] = inStock;
    }
    if (status != null) {
      parameters['status'] = status!.value;
    }
    if (searchQuery != null) {
      parameters['search'] = searchQuery;
    }
    
    return parameters;
  }
}