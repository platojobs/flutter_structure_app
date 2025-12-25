import 'package:get/get.dart';
import '../models/product.dart';

/// 购物车项目模型
class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  /// 计算该项总价
  double get totalPrice => product.finalPrice * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// 购物车控制器
class CartController extends GetxController {
  final _items = <CartItem>[].obs;

  List<CartItem> get items => _items;

  /// 购物车总价
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// 购物车总数量
  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// 购物车商品数
  int get itemCount => _items.length;

  /// 添加商品到购物车
  Future<void> addItem(Product product, {int quantity = 1}) async {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // 商品已存在，增加数量
      final existingItem = _items[existingIndex];
      _items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      // 新增商品
      _items.add(CartItem(product: product, quantity: quantity));
    }
  }

  /// 移除商品
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  /// 更新商品数量
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
  }

  /// 清空购物车
  void clear() {
    _items.clear();
  }

  /// 检查商品是否在购物车中
  bool containsProduct(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
}
