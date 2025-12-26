import 'package:flutter_application_struture/domain/entities/cart_entity.dart';
import 'package:flutter_application_struture/domain/repositories/cart_repository.dart';

/// 购物车用例
class CartUseCases {
  final CartRepository _cartRepository;

  CartUseCases(this._cartRepository);

  /// 获取购物车
  Future<Cart?> getCart(String userId) {
    return _cartRepository.getCart(userId);
  }

  /// 添加商品到购物车
  Future<CartItem> addItem(String userId, CartItem item) {
    return _cartRepository.addItem(userId, item);
  }

  /// 更新购物车项数量
  Future<CartItem> updateItemQuantity(String userId, String itemId, int quantity) {
    return _cartRepository.updateItemQuantity(userId, itemId, quantity);
  }

  /// 从购物车移除商品
  Future<bool> removeItem(String userId, String itemId) {
    return _cartRepository.removeItem(userId, itemId);
  }

  /// 清空购物车
  Future<bool> clearCart(String userId) {
    return _cartRepository.clearCart(userId);
  }

  /// 检查商品是否在购物车中
  Future<bool> isItemInCart(String userId, String productId) {
    return _cartRepository.isItemInCart(userId, productId);
  }

  /// 获取购物车商品数量
  Future<int> getCartItemCount(String userId) {
    return _cartRepository.getCartItemCount(userId);
  }

  /// 获取购物车商品总数
  Future<int> getCartTotalItems(String userId) {
    return _cartRepository.getCartTotalItems(userId);
  }

  /// 获取购物车总价
  Future<double> getCartTotalAmount(String userId) {
    return _cartRepository.getCartTotalAmount(userId);
  }

  /// 应用优惠码
  Future<Cart> applyCoupon(String userId, String couponCode) {
    return _cartRepository.applyCoupon(userId, couponCode);
  }

  /// 移除优惠码
  Future<Cart> removeCoupon(String userId) {
    return _cartRepository.removeCoupon(userId);
  }

  /// 合并购物车
  Future<Cart> mergeCart(String userId, String tempCartId) {
    return _cartRepository.mergeCart(userId, tempCartId);
  }

  /// 保存购物车
  Future<bool> saveCartOffline(Cart cart) {
    return _cartRepository.saveCartOffline(cart);
  }

  /// 获取离线购物车
  Future<Cart?> getOfflineCart() {
    return _cartRepository.getOfflineCart();
  }
}