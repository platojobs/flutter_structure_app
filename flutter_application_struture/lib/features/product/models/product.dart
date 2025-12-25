/// 商品模型
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;
  final String categoryId;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isFavorite;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.categoryId,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.isFavorite,
    required this.createdAt,
  });

  /// 复制并修改属性
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? salePrice,
    String? categoryId,
    List<String>? images,
    double? rating,
    int? reviewCount,
    int? stock,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 获取有效价格（优先使用促销价）
  double get finalPrice => salePrice ?? price;

  /// 获取折扣百分比
  double? get discountPercent {
    if (salePrice == null) return null;
    return ((price - salePrice!) / price * 100).toStringAsFixed(0).parseDouble();
  }
}

extension on String {
  double parseDouble() => double.tryParse(this) ?? 0.0;
}
