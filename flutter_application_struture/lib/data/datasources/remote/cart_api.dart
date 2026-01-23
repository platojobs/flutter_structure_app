import 'dart:io';
import 'package:flutter_application_struture/data/network/http_client.dart';
import 'package:flutter_application_struture/data/models/cart_model.dart';
import 'package:flutter_application_struture/domain/entities/cart_entity.dart';
import 'package:flutter_application_struture/data/datasources/remote/mock_data.dart';
import 'package:flutter_application_struture/core/exceptions/app_exceptions.dart';

/// 购物车API接口
class CartApi {
  final HttpClient _httpClient;
  static const String _baseUrl = '/api/cart';

  CartApi(this._httpClient);

  // 检查购物车是否存在
  bool _checkCartExists(String userId) {
    return MockData.carts.any((c) => c.userId == userId);
  }

  // 检查临时购物车是否存在
  bool _checkTempCartExists(String tempCartId) {
    return MockData.carts.any((c) => c.id == tempCartId);
  }

  // 获取用户购物车
  CartModel? _getUserCart(String userId) {
    return MockData.carts.firstWhere(
      (c) => c.userId == userId,
      orElse: () => null,
    );
  }

  // 获取临时购物车
  CartModel? _getTempCart(String tempCartId) {
    return MockData.carts.firstWhere(
      (c) => c.id == tempCartId,
      orElse: () => null,
    );
  }

  // 获取或创建模拟购物车
  CartModel _getOrCreateMockCart(String userId) {
    var cart = _getUserCart(userId);
    if (cart == null) {
      // 创建新的模拟购物车
      cart = MockData.createMockCart(userId);
      MockData.carts.add(cart);
    }
    return cart;
  }

  // 更新购物车数据
  void _updateCart(CartModel updatedCart) {
    final cartIndex = MockData.carts.indexWhere((c) => c.id == updatedCart.id);
    if (cartIndex >= 0) {
      MockData.carts[cartIndex] = updatedCart;
    }
  }

  /// 获取购物车
  Future<CartModel?> getCart(String userId) async {
    try {
      // 使用模拟数据，实际项目中可以根据需要切换到真实API
      final cart = _getOrCreateMockCart(userId);
      return cart;
      
      // 真实API调用（注释掉，使用模拟数据）
      /*final response = await _httpClient.get(
        '$_baseUrl/$userId',
      );

      if (response.statusCode == HttpStatus.ok && response.data != null) {
        return CartModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;*/
    } catch (e) {
      // 如果真实API调用失败，回退到模拟数据
      return _getOrCreateMockCart(userId);
    }
  }

  /// 添加商品到购物车
  Future<CartModel> addItem(String userId, CartItem cartItem) async {
    try {
      // 参数验证
      if (userId.isEmpty) {
        throw ValidationException(
          message: '用户ID不能为空',
          code: 'USER_ID_EMPTY',
        );
      }
      
      if (cartItem.productId.isEmpty) {
        throw ValidationException(
          message: '商品ID不能为空',
          code: 'PRODUCT_ID_EMPTY',
        );
      }
      
      if (cartItem.quantity <= 0) {
        throw ValidationException(
          message: '商品数量必须大于0',
          code: 'QUANTITY_INVALID',
        );
      }
      
      if (cartItem.price <= 0) {
        throw ValidationException(
          message: '商品价格必须大于0',
          code: 'PRICE_INVALID',
        );
      }
      
      // 使用模拟数据，实际项目中可以根据需要切换到真实API
      final cart = _getOrCreateMockCart(userId);
      final cartItemModel = CartItemModel.fromEntity(cartItem);
      
      // 检查是否已存在该商品
      final existingIndex = cart.items.indexWhere((i) => i.productId == cartItem.productId);
      
      if (existingIndex >= 0) {
        // 如果已存在，增加数量
        final existingItem = cart.items[existingIndex];
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + cartItem.quantity,
        );
        
        final updatedItems = List<CartItemModel>.from(cart.items);
        updatedItems[existingIndex] = updatedItem;
        
        final updatedCart = cart.copyWith(
          items: updatedItems,
          totalAmount: updatedItems.fold(0.0, (sum, i) => sum + i.price * i.quantity),
          updatedAt: DateTime.now(),
        );
        
        // 更新模拟数据
        _updateCart(updatedCart);
        return updatedCart;
      } else {
        // 如果不存在，添加新项
        final newItems = [...cart.items, cartItemModel];
        final updatedCart = cart.copyWith(
          items: newItems,
          totalAmount: newItems.fold(0.0, (sum, i) => sum + i.price * i.quantity),
          updatedAt: DateTime.now(),
        );
        
        // 更新模拟数据
        _updateCart(updatedCart);
        return updatedCart;
      }
      
      // 真实API调用（注释掉，使用模拟数据）
      /*final response = await _httpClient.post(
        '$_baseUrl/$userId/items',
        data: cartItem.toJson(),
      );

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) && response.data != null) {
        return CartModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('添加购物车项失败');*/
    } catch (e) {
      // 如果真实API调用失败，回退到模拟数据
      final cart = _getOrCreateMockCart(userId);
      return cart;
    }
  }

  /// 更新购物车项数量
  Future<CartModel> updateItemQuantity(String userId, String itemId, int quantity) async {
    try {
      // 参数验证
      if (userId.isEmpty) {
        throw ValidationException(
          message: '用户ID不能为空',
          code: 'USER_ID_EMPTY',
        );
      }
      
      if (itemId.isEmpty) {
        throw ValidationException(
          message: '购物车项ID不能为空',
          code: 'ITEM_ID_EMPTY',
        );
      }
      
      if (quantity <= 0) {
        throw ValidationException(
          message: '商品数量必须大于0',
          code: 'QUANTITY_INVALID',
        );
      }
      
      // 使用模拟数据，实际项目中可以根据需要切换到真实API
      final cart = _getOrCreateMockCart(userId);
      
      // 查找要更新的购物车项
      final existingIndex = cart.items.indexWhere((i) => i.id == itemId);
      
      if (existingIndex >= 0) {
        // 如果存在，更新数量
        final existingItem = cart.items[existingIndex];
        final updatedItem = existingItem.copyWith(
          quantity: quantity,
        );
        
        final updatedItems = List<CartItemModel>.from(cart.items);
        updatedItems[existingIndex] = updatedItem;
        
        final updatedCart = cart.copyWith(
          items: updatedItems,
          totalAmount: updatedItems.fold(0.0, (sum, i) => sum + i.price * i.quantity),
          updatedAt: DateTime.now(),
        );
        
        // 更新模拟数据
        _updateCart(updatedCart);
        return updatedCart;
      } else {
        // 如果不存在，抛出异常
        throw ServerException(
          message: '购物车项不存在',
          code: 'CART_ITEM_NOT_FOUND',
        );
      }
    } catch (e) {
      // 如果真实API调用失败或抛出验证异常，回退到模拟数据
      return _getOrCreateMockCart(userId);
    }
  }

  /// 从购物车移除商品
  Future<bool> removeItem(String userId, String itemId) async {
    try {
      // 参数验证
      if (userId.isEmpty) {
        throw ValidationException(
          message: '用户ID不能为空',
          code: 'USER_ID_EMPTY',
        );
      }
      
      if (itemId.isEmpty) {
        throw ValidationException(
          message: '购物车项ID不能为空',
          code: 'ITEM_ID_EMPTY',
        );
      }
      
      // 使用模拟数据，实际项目中可以根据需要切换到真实API
      final cart = _getUserCart(userId);
      
      if (cart == null) {
        throw ServerException(
          message: '购物车不存在',
          code: 'CART_NOT_FOUND',
        );
      }
      
      // 查找要移除的购物车项
      final existingIndex = cart.items.indexWhere((i) => i.id == itemId);
      
      if (existingIndex >= 0) {
        // 如果存在，移除该项
        final updatedItems = List<CartItemModel>.from(cart.items);
        updatedItems.removeAt(existingIndex);
        
        final updatedCart = cart.copyWith(
          items: updatedItems,
          totalAmount: updatedItems.fold(0.0, (sum, i) => sum + i.price * i.quantity),
          updatedAt: DateTime.now(),
        );
        
        // 更新模拟数据
        _updateCart(updatedCart);
        return true;
      } else {
        throw ServerException(
          message: '购物车项不存在',
          code: 'CART_ITEM_NOT_FOUND',
        );
      }
    } catch (e) {
      // 处理验证异常和服务器异常，返回false表示操作失败
      return false;
    }
  }

  /// 清空购物车
  Future<bool> clearCart(String userId) async {
    try {
      // 参数验证
      if (userId.isEmpty) {
        throw ValidationException(
          message: '用户ID不能为空',
          code: 'USER_ID_EMPTY',
        );
      }
      
      // 使用模拟数据，实际项目中可以根据需要切换到真实API
      final cart = _getUserCart(userId);
      
      if (cart == null) {
        throw ServerException(
          message: '购物车不存在',
          code: 'CART_NOT_FOUND',
        );
      }
      
      // 清空购物车项
      final updatedCart = cart.copyWith(
        items: [],
        totalAmount: 0.0,
        couponCode: null,
        discount: 0.0,
        updatedAt: DateTime.now(),
      );
      
      // 更新模拟数据
      _updateCart(updatedCart);
      return true;
    } catch (e) {
      // 处理验证异常和服务器异常，返回false表示操作失败
      return false;
    }
  }

  /// 应用优惠码
  Future<CartModel> applyCoupon(String userId, String couponCode) async {
    try {
      // 参数验证
      if (userId.isEmpty) {
        throw ValidationException(
          message: '用户ID不能为空',
          code: 'USER_ID_EMPTY',
        );
      }
      
      if (couponCode.isEmpty) {
        throw ValidationException(
          message: '优惠码不能为空',
          code: 'COUPON_CODE_EMPTY',
        );
      }
      
      // 使用模拟数据，实际项目中可以根据需要切换到真实API
      final cart = _getOrCreateMockCart(userId);
      
      // 模拟优惠码逻辑
      double discount = 0.0;
      String appliedCouponCode = '';
      String validCoupons = 'DISCOUNT10,DISCOUNT20,FIXED50';
      
      // 检查优惠码是否有效
      if (!validCoupons.contains(couponCode)) {
        throw ServerException(
          message: '无效的优惠码',
          code: 'COUPON_INVALID',
        );
      }
      
      // 支持多种优惠码
      if (couponCode == 'DISCOUNT10') {
        discount = 0.1; // 10%折扣
        appliedCouponCode = couponCode;
      } else if (couponCode == 'DISCOUNT20') {
        discount = 0.2; // 20%折扣
        appliedCouponCode = couponCode;
      } else if (couponCode == 'FIXED50') {
        if (cart.totalAmount < 500) {
          throw ServerException(
            message: '满500才能使用此优惠码',
            code: 'COUPON_MINIMUM_AMOUNT',
          );
        }
        discount = 50.0; // 满500减50
        appliedCouponCode = couponCode;
      }
      
      final finalAmount = couponCode == 'FIXED50' 
          ? (cart.totalAmount - discount)
          : cart.totalAmount * (1 - discount);
      
      final updatedCart = cart.copyWith(
        couponCode: appliedCouponCode,
        discount: discount,
        totalAmount: finalAmount,
        updatedAt: DateTime.now(),
      );
      
      // 更新模拟数据
      _updateCart(updatedCart);
      return updatedCart;
    } catch (e) {
      // 如果真实API调用失败或抛出验证异常，回退到模拟数据
      return _getOrCreateMockCart(userId);
    }
  }

  /// 移除优惠码
  Future<CartModel> removeCoupon(String userId) async {
    try {
      // 参数验证
      if (userId.isEmpty) {
        throw ValidationException(
          message: '用户ID不能为空',
          code: 'USER_ID_EMPTY',
        );
      }
      
      // 使用模拟数据，实际项目中可以根据需要切换到真实API
      final cart = _getOrCreateMockCart(userId);
      
      // 移除优惠码，重新计算总价
      final updatedCart = cart.copyWith(
        couponCode: null,
        discount: 0.0,
        totalAmount: cart.items.fold(0.0, (sum, i) => sum + i.price * i.quantity),
        updatedAt: DateTime.now(),
      );
      
      // 更新模拟数据
      _updateCart(updatedCart);
      return updatedCart;
    } catch (e) {
      // 如果真实API调用失败或抛出验证异常，回退到模拟数据
      return _getOrCreateMockCart(userId);
    }
  }

  /// 合并购物车
  Future<CartModel> mergeCart(String userId, String tempCartId) async {
    try {
      // 参数验证
      if (userId.isEmpty) {
        throw ValidationException(
          message: '用户ID不能为空',
          code: 'USER_ID_EMPTY',
        );
      }
      
      if (tempCartId.isEmpty) {
        throw ValidationException(
          message: '临时购物车ID不能为空',
          code: 'TEMP_CART_ID_EMPTY',
        );
      }
      
      // 使用模拟数据，实际项目中可以根据需要切换到真实API
      final userCart = _getOrCreateMockCart(userId);
      
      // 查找临时购物车
      final tempCart = _getTempCart(tempCartId);
      
      if (tempCart == null) {
        throw ServerException(
          message: '临时购物车不存在',
          code: 'TEMP_CART_NOT_FOUND',
        );
      }
      
      // 合并购物车项
      final mergedItems = List<CartItemModel>.from(userCart.items);
      
      for (final tempItem in tempCart.items) {
        // 检查是否已存在该商品
        final existingIndex = mergedItems.indexWhere((i) => i.productId == tempItem.productId);
        
        if (existingIndex >= 0) {
          // 如果已存在，增加数量
          final existingItem = mergedItems[existingIndex];
          final updatedItem = existingItem.copyWith(
            quantity: existingItem.quantity + tempItem.quantity,
          );
          mergedItems[existingIndex] = updatedItem;
        } else {
          // 如果不存在，添加新项
          mergedItems.add(tempItem);
        }
      }
      
      final updatedCart = userCart.copyWith(
        items: mergedItems,
        totalAmount: mergedItems.fold(0.0, (sum, i) => sum + i.price * i.quantity),
        updatedAt: DateTime.now(),
      );
      
      // 更新模拟数据
      _updateCart(updatedCart);
      
      // 移除临时购物车
      MockData.carts.remove(tempCart);
      
      return updatedCart;
    } catch (e) {
      // 如果真实API调用失败或抛出验证异常，回退到模拟数据
      return _getOrCreateMockCart(userId);
    }
  }
}