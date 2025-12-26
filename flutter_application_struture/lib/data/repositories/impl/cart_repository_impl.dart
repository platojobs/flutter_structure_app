import 'package:flutter_application_struture/data/datasources/cache/cache_manager.dart';
import 'package:flutter_application_struture/data/datasources/remote/cart_api.dart';
import 'package:flutter_application_struture/data/models/cart_model.dart';
import 'package:flutter_application_struture/domain/entities/cart_entity.dart';
import 'package:flutter_application_struture/domain/repositories/cart_repository.dart';

/// 购物车仓库实现
class CartRepositoryImpl implements CartRepository {
  final CartApi _cartApi;
  final CacheManager _cacheManager;

  CartRepositoryImpl({
    required CartApi cartApi,
    required CacheManager cacheManager,
  }) : _cartApi = cartApi,
       _cacheManager = cacheManager;

  @override
  Future<Cart?> getCart(String userId) async {
    try {
      // 先尝试从缓存获取
      final cachedCart = await _cacheManager.getCart(userId);
      if (cachedCart != null) {
        return cachedCart;
      }

      // 缓存中没有，从API获取
      final cartModel = await _cartApi.getCart(userId);
      if (cartModel != null) {
        // 缓存数据
        await _cacheManager.saveCart(userId, cartModel);
        // 转换为实体返回
        return cartModel.toEntity();
      }
      return null;
    } catch (e) {
      // 出错时尝试从缓存获取最后一次成功的缓存
      final cachedCart = await _cacheManager.getLastCachedCart(userId);
      if (cachedCart != null) {
        return cachedCart.toEntity();
      }
      rethrow;
    }
  }

  @override
  Future<CartItem> addItem(String userId, CartItem item) async {
    try {
      // 先更新本地缓存
      final existingCart = await getCart(userId);
      if (existingCart != null) {
        // 检查是否已存在该商品
        final existingIndex = existingCart.items
            .indexWhere((i) => i.productId == item.productId);
        
        if (existingIndex >= 0) {
          // 如果已存在，增加数量
          final existingItem = existingCart.items[existingIndex];
          final updatedItem = existingItem.copyWith(
            quantity: existingItem.quantity + item.quantity,
          );
          
          final updatedItems = List<CartItem>.from(existingCart.items);
          updatedItems[existingIndex] = updatedItem;
          
          final updatedCart = existingCart.copyWith(
            items: updatedItems,
            totalAmount: updatedItems.fold(0.0, (sum, i) => sum + i.totalPrice),
            updatedAt: DateTime.now(),
          );
          
          // 保存到缓存
          await _cacheManager.saveCart(userId, CartModel.fromEntity(updatedCart));
        } else {
          // 如果不存在，添加新项
          final newItems = [...existingCart.items, item];
          final updatedCart = existingCart.copyWith(
            items: newItems,
            totalAmount: newItems.fold(0.0, (sum, i) => sum + i.totalPrice),
            updatedAt: DateTime.now(),
          );
          
          // 保存到缓存
          await _cacheManager.saveCart(userId, CartModel.fromEntity(updatedCart));
        }
      } else {
        // 如果购物车为空，创建新购物车
        final now = DateTime.now();
        final newCart = Cart(
          id: 'cart_$userId',
          userId: userId,
          items: [item],
          createdAt: now,
          updatedAt: now,
          totalAmount: item.totalPrice,
        );
        
        // 保存到缓存
        await _cacheManager.saveCart(userId, CartModel.fromEntity(newCart));
      }
      
      // 同步到服务器
      final cartModel = await _cartApi.addItem(userId, item);
      
      // 返回添加的项
      return cartModel.items.firstWhere(
        (i) => i.productId == item.productId,
      ).toEntity();
    } catch (e) {
      // 出错时返回本地操作结果
      return item;
    }
  }

  @override
  Future<CartItem> updateItemQuantity(String userId, String itemId, int quantity) async {
    try {
      final cart = await getCart(userId);
      if (cart == null) {
        throw Exception('购物车不存在');
      }
      
      // 查找商品
      final itemIndex = cart.items.indexWhere((i) => i.id == itemId);
      if (itemIndex < 0) {
        throw Exception('商品不存在于购物车中');
      }
      
      // 更新数量或移除商品
      final updatedItems = List<CartItem>.from(cart.items);
      
      if (quantity <= 0) {
        // 如果数量为0或小于0，移除商品
        updatedItems.removeAt(itemIndex);
      } else {
        // 更新数量
        updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
          quantity: quantity,
        );
      }
      
      final updatedCart = cart.copyWith(
        items: updatedItems,
        totalAmount: updatedItems.fold(0.0, (sum, i) => sum + i.totalPrice),
        updatedAt: DateTime.now(),
      );
      
      // 保存到缓存
      await _cacheManager.saveCart(userId, CartModel.fromEntity(updatedCart));
      
      // 同步到服务器
      await _cartApi.updateItemQuantity(userId, itemId, quantity);
      
      // 返回更新后的项（如果数量大于0）
      if (quantity > 0) {
        return updatedItems[itemIndex].toEntity();
      } else {
        // 如果数量为0，返回原始项（已从购物车移除）
        return cart.items[itemIndex].toEntity();
      }
    } catch (e) {
      // 出错时尝试从服务器获取最新数据
      rethrow;
    }
  }

  @override
  Future<bool> removeItem(String userId, String itemId) async {
    try {
      final cart = await getCart(userId);
      if (cart == null) {
        throw Exception('购物车不存在');
      }
      
      // 查找并移除商品
      final itemToRemove = cart.items.firstWhere((i) => i.id == itemId);
      final updatedItems = cart.items.where((i) => i.id != itemId).toList();
      
      final updatedCart = cart.copyWith(
        items: updatedItems,
        totalAmount: updatedItems.fold(0.0, (sum, i) => sum + i.totalPrice),
        updatedAt: DateTime.now(),
      );
      
      // 保存到缓存
      await _cacheManager.saveCart(userId, CartModel.fromEntity(updatedCart));
      
      // 同步到服务器
      await _cartApi.removeItem(userId, itemId);
      
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> clearCart(String userId) async {
    try {
      // 清空缓存
      await _cacheManager.clearCart(userId);
      
      // 同步到服务器
      await _cartApi.clearCart(userId);
      
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isItemInCart(String userId, String productId) async {
    try {
      final cart = await getCart(userId);
      if (cart == null) return false;
      
      return cart.items.any((item) => item.productId == productId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getCartItemCount(String userId) async {
    try {
      final cart = await getCart(userId);
      if (cart == null) return 0;
      
      return cart.itemCount;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<int> getCartTotalItems(String userId) async {
    try {
      final cart = await getCart(userId);
      if (cart == null) return 0;
      
      return cart.uniqueItemCount;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<double> getCartTotalAmount(String userId) async {
    try {
      final cart = await getCart(userId);
      if (cart == null) return 0.0;
      
      return cart.calculateTotalAmount();
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Future<Cart> applyCoupon(String userId, String couponCode) async {
    try {
      // 同步到服务器
      final cartModel = await _cartApi.applyCoupon(userId, couponCode);
      
      // 转换为实体
      final cart = cartModel.toEntity();
      
      // 保存到缓存
      await _cacheManager.saveCart(userId, cartModel);
      
      return cart;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> removeCoupon(String userId) async {
    try {
      // 同步到服务器
      final cartModel = await _cartApi.removeCoupon(userId);
      
      // 转换为实体
      final cart = cartModel.toEntity();
      
      // 保存到缓存
      await _cacheManager.saveCart(userId, cartModel);
      
      return cart;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> mergeCart(String userId, String tempCartId) async {
    try {
      // 同步到服务器
      final cartModel = await _cartApi.mergeCart(userId, tempCartId);
      
      // 转换为实体
      final cart = cartModel.toEntity();
      
      // 保存到缓存
      await _cacheManager.saveCart(userId, cartModel);
      
      return cart;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveCartOffline(Cart cart) async {
    try {
      // 保存到本地存储
      final cartModel = CartModel.fromEntity(cart);
      return await _cacheManager.saveOfflineCart(cartModel);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Cart?> getOfflineCart() async {
    try {
      // 从本地存储获取
      final cartModel = await _cacheManager.getOfflineCart();
      if (cartModel != null) {
        return cartModel.toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}