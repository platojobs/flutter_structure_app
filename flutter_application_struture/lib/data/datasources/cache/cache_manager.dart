import 'dart:convert';
import 'package:flutter_application_struture/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 缓存管理器
class CacheManager {
  static const String _cartKey = 'cart_';
  static const String _offlineCartKey = 'offline_cart';

  /// 获取购物车缓存
  Future<CartModel?> getCart(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('$_cartKey$userId');
      
      if (cartJson != null) {
        return CartModel.fromJson(json.decode(cartJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 保存购物车缓存
  Future<bool> saveCart(String userId, CartModel cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(cart.toJson());
      
      return await prefs.setString('$_cartKey$userId', cartJson);
    } catch (e) {
      return false;
    }
  }

  /// 清除购物车缓存
  Future<bool> clearCart(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove('$_cartKey$userId');
    } catch (e) {
      return false;
    }
  }

  /// 获取最后缓存的购物车
  Future<CartModel?> getLastCachedCart(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('$_cartKey${userId}_last');
      
      if (cartJson != null) {
        return CartModel.fromJson(json.decode(cartJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 保存离线购物车
  Future<bool> saveOfflineCart(CartModel cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(cart.toJson());
      
      return await prefs.setString(_offlineCartKey, cartJson);
    } catch (e) {
      return false;
    }
  }

  /// 获取离线购物车
  Future<CartModel?> getOfflineCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_offlineCartKey);
      
      if (cartJson != null) {
        return CartModel.fromJson(json.decode(cartJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 清除离线购物车
  Future<bool> clearOfflineCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_offlineCartKey);
    } catch (e) {
      return false;
    }
  }
}