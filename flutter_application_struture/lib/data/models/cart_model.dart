import 'package:flutter_application_struture/domain/entities/cart_entity.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;
  final Map<String, dynamic>? options;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.options,
  });

  // 从实体转换为模型
  factory CartItemModel.fromEntity(CartItem cartItem) {
    return CartItemModel(
      id: cartItem.id,
      productId: cartItem.productId,
      productName: cartItem.productName,
      price: cartItem.price,
      quantity: cartItem.quantity,
      imageUrl: cartItem.imageUrl,
      options: cartItem.options,
    );
  }

  // 转换为实体
  CartItem toEntity() {
    return CartItem(
      id: id,
      productId: productId,
      productName: productName,
      price: price,
      quantity: quantity,
      imageUrl: imageUrl,
      options: options,
    );
  }

  // 从JSON创建模型
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      price: json['price'] as double,
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
      options: json['options'] as Map<String, dynamic>?,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'options': options,
    };
  }

  // 创建模型副本
  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? imageUrl,
    Map<String, dynamic>? options,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      options: options ?? this.options,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.id == id &&
        other.productId == productId &&
        other.productName == productName &&
        other.price == price &&
        other.quantity == quantity &&
        other.imageUrl == imageUrl &&
        _mapsEqual(other.options, options);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productId,
      productName,
      price,
      quantity,
      imageUrl,
      options,
    );
  }

  bool _mapsEqual(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    
    for (var key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double totalAmount;

  const CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    required this.totalAmount,
  });

  // 从实体转换为模型
  factory CartModel.fromEntity(Cart cart) {
    return CartModel(
      id: cart.id,
      userId: cart.userId,
      items: cart.items.map((item) => CartItemModel.fromEntity(item)).toList(),
      createdAt: cart.createdAt,
      updatedAt: cart.updatedAt,
      totalAmount: cart.totalAmount,
    );
  }

  // 转换为实体
  Cart toEntity() {
    return Cart(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      totalAmount: totalAmount,
    );
  }

  // 从JSON创建模型
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      totalAmount: json['totalAmount'] as double,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'totalAmount': totalAmount,
    };
  }

  // 创建模型副本
  CartModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? totalAmount,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartModel &&
        other.id == id &&
        other.userId == userId &&
        _listsEqual(other.items, items) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.totalAmount == totalAmount;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      Object.hashAll(items),
      createdAt,
      updatedAt,
      totalAmount,
    );
  }

  bool _listsEqual(List<CartItemModel> a, List<CartItemModel> b) {
    if (a.length != b.length) return false;
    
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}