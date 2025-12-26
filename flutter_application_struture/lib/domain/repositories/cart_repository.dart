import 'package:flutter_application_struture/domain/entities/cart_entity.dart';

/// 购物车仓库接口
abstract class CartRepository {
  /// 获取用户购物车
  Future<Cart?> getCart(String userId);

  /// 添加商品到购物车
  Future<CartItem> addItem(String userId, CartItem item);

  /// 更新购物车项数量
  Future<CartItem> updateItemQuantity(String userId, String itemId, int quantity);

  /// 从购物车移除商品
  Future<bool> removeItem(String userId, String itemId);

  /// 清空购物车
  Future<bool> clearCart(String userId);

  /// 检查商品是否在购物车中
  Future<bool> isItemInCart(String userId, String productId);

  /// 获取购物车商品数量
  Future<int> getCartItemCount(String userId);

  /// 获取购物车商品总数
  Future<int> getCartTotalItems(String userId);

  /// 获取购物车总价
  Future<double> getCartTotalAmount(String userId);

  /// 应用优惠码
  Future<Cart> applyCoupon(String userId, String couponCode);

  /// 移除优惠码
  Future<Cart> removeCoupon(String userId);

  /// 合并购物车（登录后）
  Future<Cart> mergeCart(String userId, String tempCartId);

  /// 保存购物车（用于离线）
  Future<bool> saveCartOffline(Cart cart);

  /// 获取离线购物车
  Future<Cart?> getOfflineCart();
}