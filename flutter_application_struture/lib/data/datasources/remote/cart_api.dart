import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_application_struture/data/network/http_client.dart';
import 'package:flutter_application_struture/data/models/cart_model.dart';
import 'package:flutter_application_struture/domain/entities/cart_entity.dart';

/// 购物车API接口
class CartApi {
  final HttpClient _httpClient;
  static const String _baseUrl = '/api/cart';

  CartApi(this._httpClient);

  /// 获取购物车
  Future<CartModel?> getCart(String userId) async {
    try {
      final response = await _httpClient.get(
        '$_baseUrl/$userId',
      );

      if (response.statusCode == HttpStatus.ok) {
        return CartModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// 添加商品到购物车
  Future<CartModel> addItem(String userId, CartItem cartItem) async {
    try {
      final response = await _httpClient.post(
        '$_baseUrl/$userId/items',
        data: cartItem.toJson(),
      );

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        return CartModel.fromJson(response.data);
      }
      throw Exception('添加购物车项失败');
    } catch (e) {
      rethrow;
    }
  }

  /// 更新购物车项数量
  Future<CartModel> updateItemQuantity(String userId, String itemId, int quantity) async {
    try {
      final response = await _httpClient.patch(
        '$_baseUrl/$userId/items/$itemId',
        data: {'quantity': quantity},
      );

      if (response.statusCode == HttpStatus.ok) {
        return CartModel.fromJson(response.data);
      }
      throw Exception('更新购物车项失败');
    } catch (e) {
      rethrow;
    }
  }

  /// 从购物车移除商品
  Future<bool> removeItem(String userId, String itemId) async {
    try {
      final response = await _httpClient.delete(
        '$_baseUrl/$userId/items/$itemId',
      );

      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// 清空购物车
  Future<bool> clearCart(String userId) async {
    try {
      final response = await _httpClient.delete(
        '$_baseUrl/$userId',
      );

      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// 应用优惠码
  Future<CartModel> applyCoupon(String userId, String couponCode) async {
    try {
      final response = await _httpClient.post(
        '$_baseUrl/$userId/coupons',
        data: {'couponCode': couponCode},
      );

      if (response.statusCode == HttpStatus.ok) {
        return CartModel.fromJson(response.data);
      }
      throw Exception('应用优惠码失败');
    } catch (e) {
      rethrow;
    }
  }

  /// 移除优惠码
  Future<CartModel> removeCoupon(String userId) async {
    try {
      final response = await _httpClient.delete(
        '$_baseUrl/$userId/coupons',
      );

      if (response.statusCode == HttpStatus.ok) {
        return CartModel.fromJson(response.data);
      }
      throw Exception('移除优惠码失败');
    } catch (e) {
      rethrow;
    }
  }

  /// 合并购物车
  Future<CartModel> mergeCart(String userId, String tempCartId) async {
    try {
      final response = await _httpClient.post(
        '$_baseUrl/$userId/merge',
        data: {'tempCartId': tempCartId},
      );

      if (response.statusCode == HttpStatus.ok) {
        return CartModel.fromJson(response.data);
      }
      throw Exception('合并购物车失败');
    } catch (e) {
      rethrow;
    }
  }
}