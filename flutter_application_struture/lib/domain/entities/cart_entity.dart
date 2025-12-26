class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;
  final Map<String, dynamic>? options;

  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.options,
  });

  // 计算该购物车项的总价
  double get totalPrice => price * quantity;

  // 创建购物车项副本，可选地更新某些属性
  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? imageUrl,
    Map<String, dynamic>? options,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      options: options ?? this.options,
    );
  }

  // 从JSON创建购物车项
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
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

class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double totalAmount;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    required this.totalAmount,
  });

  // 计算购物车总价
  double calculateTotalAmount() {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // 购物车中商品总数
  int get itemCount => items.fold(0, (count, item) => count + item.quantity);

  // 购物车中不同商品种类数
  int get uniqueItemCount => items.length;

  // 购物车是否为空
  bool get isEmpty => items.isEmpty;

  // 购物车是否不为空
  bool get isNotEmpty => items.isNotEmpty;

  // 创建购物车副本
  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? totalAmount,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalAmount: totalAmount ?? calculateTotalAmount(),
    );
  }

  // 从JSON创建购物车
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cart &&
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

  bool _listsEqual(List<CartItem> a, List<CartItem> b) {
    if (a.length != b.length) return false;
    
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}