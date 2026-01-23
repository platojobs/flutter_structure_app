import 'dart:math';
import 'package:flutter_application_struture/data/models/cart_model.dart';

/// 模拟数据管理类
class MockData {
  // 模拟购物车数据
  static final List<CartModel> carts = [];

  // 生成随机价格
  static double _generateRandomPrice() {
    final random = Random();
    return (100 + random.nextDouble() * 9900).roundToDouble();
  }

  // 生成随机数量
  static int _generateRandomQuantity() {
    final random = Random();
    return 1 + random.nextInt(5);
  }

  // 生成模拟购物车项
  static CartItemModel createMockCartItem([String? productId, String? productName]) {
    final randomProductId = productId ?? 'product_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
    final randomProductName = productName ?? _getRandomProductName();
    final category = _getRandomCategory();
    
    // 根据类别添加不同的选项
    Map<String, dynamic> options = {};
    if (category == 'electronics') {
      options = {
        'color': _getRandomColor(),
        'storage': '${32 + Random().nextInt(256)}GB',
        'brand': ['Apple', 'Samsung', 'Huawei', 'Xiaomi', 'Sony'][Random().nextInt(5)]
      };
    } else if (category == 'clothing' || category == 'sports') {
      options = {
        'color': _getRandomColor(),
        'size': _getRandomSize(),
        'material': ['cotton', 'polyester', 'wool', 'silk', 'leather'][Random().nextInt(5)]
      };
    } else if (category == 'home' || category == 'beauty') {
      options = {
        'color': _getRandomColor(),
        'size': ['small', 'medium', 'large', 'xlarge'][Random().nextInt(4)]
      };
    } else if (category == 'books') {
      options = {
        'format': ['paperback', 'hardcover', 'e-book'][Random().nextInt(3)],
        'language': ['Chinese', 'English', 'Japanese'][Random().nextInt(3)]
      };
    }
    
    return CartItemModel(
      id: 'cart_item_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}',
      productId: randomProductId,
      productName: randomProductName,
      price: _generateRandomPrice(),
      quantity: _generateRandomQuantity(),
      imageUrl: 'https://via.placeholder.com/100',
      category: category,
      options: options,
    );
  }

  // 生成随机颜色
  static String _getRandomColor() {
    final colors = ['red', 'blue', 'green', 'black', 'white', 'gray', 'yellow', 'purple', 'pink', 'orange', 'cyan', 'brown'];
    return colors[Random().nextInt(colors.length)];
  }

  // 生成随机尺寸
  static String _getRandomSize() {
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
    return sizes[Random().nextInt(sizes.length)];
  }

  // 生成随机商品类别
  static String _getRandomCategory() {
    final categories = ['electronics', 'clothing', 'home', 'sports', 'books', 'beauty', 'food', 'toys'];
    return categories[Random().nextInt(categories.length)];
  }

  // 生成随机商品名称
  static String _getRandomProductName() {
    final productNames = [
      '智能手机', '无线耳机', '笔记本电脑', '智能手表', '平板电脑',
      '运动T恤', '牛仔裤', '运动鞋', '羽绒服', '连衣裙',
      '咖啡机', '空气净化器', '扫地机器人', '电热水壶', '微波炉',
      '跑步鞋', '篮球', '瑜伽垫', '健身器材', '羽毛球拍',
      '科幻小说', '历史书籍', '烹饪书', '儿童绘本', '文学作品',
      '洗发水', '护肤品', '化妆品', '香水', '牙膏',
      '巧克力', '薯片', '饮料', '零食', '水果',
      '拼图', '积木', '玩具车', '玩偶', '电子游戏'
    ];
    return productNames[Random().nextInt(productNames.length)];
  }

  // 创建模拟购物车
  static CartModel createMockCart(String userId, {bool isEmpty = false, int? itemCount}) {
    final cartId = 'cart_$userId';
    final now = DateTime.now();
    
    if (isEmpty) {
      // 创建空购物车
      return CartModel(
        id: cartId,
        userId: userId,
        items: [],
        createdAt: now,
        updatedAt: now,
        totalAmount: 0.0,
      );
    }

    // 创建包含随机数量商品的购物车
    final randomItemCount = itemCount ?? (1 + Random().nextInt(8)); // 1-8个商品
    final items = List.generate(randomItemCount, (index) => createMockCartItem());

    return CartModel(
      id: cartId,
      userId: userId,
      items: items,
      createdAt: now,
      updatedAt: now,
      totalAmount: items.fold(0.0, (sum, item) => sum + item.price * item.quantity),
    );
  }

  // 创建带优惠券的模拟购物车
  static CartModel createMockCartWithCoupon(String userId) {
    final cart = createMockCart(userId);
    final couponTypes = ['DISCOUNT10', 'DISCOUNT20', 'DISCOUNT30', 'FIXED50', 'FIXED100', 'FREE_SHIPPING'];
    final couponCode = couponTypes[Random().nextInt(couponTypes.length)];
    
    double discount = 0.0;
    double finalAmount = cart.totalAmount;
    
    switch (couponCode) {
      case 'DISCOUNT10':
        discount = 0.1; // 10%折扣
        finalAmount = cart.totalAmount * (1 - discount);
        break;
      case 'DISCOUNT20':
        discount = 0.2; // 20%折扣
        finalAmount = cart.totalAmount * (1 - discount);
        break;
      case 'DISCOUNT30':
        discount = 0.3; // 30%折扣
        finalAmount = cart.totalAmount * (1 - discount);
        break;
      case 'FIXED50':
        discount = 50.0; // 固定减50
        finalAmount = cart.totalAmount >= 500 ? cart.totalAmount - discount : cart.totalAmount;
        break;
      case 'FIXED100':
        discount = 100.0; // 固定减100
        finalAmount = cart.totalAmount >= 1000 ? cart.totalAmount - discount : cart.totalAmount;
        break;
      case 'FREE_SHIPPING':
        discount = 0.0; // 免运费
        break;
    }
    
    return cart.copyWith(
      couponCode: couponCode,
      discount: discount,
      totalAmount: finalAmount,
      freeShipping: couponCode == 'FREE_SHIPPING',
    );
  }
  
  // 创建临时购物车
  static CartModel createTempCart() {
    final tempCartId = 'temp_cart_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
    final now = DateTime.now();
    
    // 临时购物车可以有0-3个商品
    final itemCount = Random().nextInt(4);
    final items = List.generate(itemCount, (index) => createMockCartItem());
    
    return CartModel(
      id: tempCartId,
      userId: '', // 临时购物车没有用户ID
      items: items,
      createdAt: now,
      updatedAt: now,
      totalAmount: items.fold(0.0, (sum, item) => sum + item.price * item.quantity),
      isTemp: true,
    );
  }
}