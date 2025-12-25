import 'package:flutter_application_struture/core/base/base_repository.dart';
import '../models/product.dart';

enum SortBy { newest, priceLow, priceHigh, rating }

/// 商品仓库
class ProductRepository extends BaseRepository {
  /// 模拟商品数据
  static final _mockProducts = List.generate(
    50,
    (i) => Product(
      id: 'prod_$i',
      name: '商品 $i',
      description: '这是商品 $i 的描述',
      price: 100.0 + (i * 10),
      salePrice: i % 3 == 0 ? 80.0 + (i * 10) : null,
      categoryId: 'cat_${i % 5}',
      images: [
        'https://via.placeholder.com/300?text=Product+$i'
      ],
      rating: 4.0 + (i % 10) / 10,
      reviewCount: 100 + i * 5,
      stock: 50 + i,
      isFavorite: false,
      createdAt: DateTime.now().subtract(Duration(days: i)),
    ),
  );

  /// 获取商品列表
  Future<List<Product>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? searchQuery,
    Map<String, dynamic>? filters,
    String? sortBy,
    dynamic sortOrder,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));

    var result = List<Product>.from(_mockProducts);

    // 按分类筛选
    if (categoryId != null) {
      result = result.where((p) => p.categoryId == categoryId).toList();
    }

    // 按搜索词筛选
    if (searchQuery != null && searchQuery.isNotEmpty) {
      result = result.where((p) => p.name.contains(searchQuery)).toList();
    }

    // 价格范围筛选
    if (filters != null) {
      if (filters['minPrice'] != null) {
        final minPrice = filters['minPrice'] as double;
        result = result.where((p) => p.finalPrice >= minPrice).toList();
      }
      if (filters['maxPrice'] != null) {
        final maxPrice = filters['maxPrice'] as double;
        result = result.where((p) => p.finalPrice <= maxPrice).toList();
      }
    }

    // 分页
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= result.length) {
      return [];
    }

    return result.sublist(
      startIndex,
      endIndex > result.length ? result.length : endIndex,
    );
  }

  /// 获取商品详情
  Future<Product?> getProductDetail(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockProducts.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  /// 搜索商品
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
