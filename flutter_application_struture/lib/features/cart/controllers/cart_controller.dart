import 'package:flutter/material.dart';
import 'package:flutter_application_struture/domain/entities/cart_entity.dart';
import 'package:flutter_application_struture/domain/usecases/cart_usecases.dart';
import 'package:get/get.dart';

/// 购物车控制器
class CartController extends GetxController {
  final CartUseCases _cartUseCases;
  
  // 状态变量
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxList<CartItem> _items = <CartItem>[].obs;
  final RxDouble _totalAmount = 0.0.obs;
  final RxInt _itemCount = 0.obs;
  final RxBool _isEmpty = true.obs;
  final RxBool _isEditMode = false.obs;
  final RxList<String> _selectedItems = <String>[].obs;
  final RxBool _canLoadMore = false.obs;
  final RxString _appliedCoupon = ''.obs;
  final TextEditingController _couponController = TextEditingController();
  
  // Getters
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  List<CartItem> get items => _items;
  double get totalAmount => _totalAmount.value;
  int get itemCount => _itemCount.value;
  bool get isEmpty => _isEmpty.value;
  bool get isNotEmpty => !_isEmpty.value;
  bool get isEditMode => _isEditMode.value;
  List<String> get selectedItems => _selectedItems;
  bool get canLoadMore => _canLoadMore.value;
  String get appliedCoupon => _appliedCoupon.value;
  TextEditingController get couponController => _couponController;
  
  // 计算属性
  bool get isAllSelected => 
      _items.isNotEmpty && _selectedItems.length == _items.length;
  
  bool get canCheckout => _selectedItems.isNotEmpty;
  
  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }
  
  CartController({
    required CartUseCases cartUseCases,
  }) : _cartUseCases = cartUseCases;
  
  @override
  void onClose() {
    _couponController.dispose();
    super.onClose();
  }
  
  /// 加载购物车
  Future<void> _loadCart() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      // 获取当前用户ID
      final String userId = await _getCurrentUserId();
      
      // 获取购物车
      final cart = await _cartUseCases.getCart(userId);
      
      if (cart != null) {
        _items.value = cart.items;
        _totalAmount.value = cart.calculateTotalAmount();
        _itemCount.value = cart.itemCount;
        _isEmpty.value = cart.isEmpty;
      } else {
        _items.value = [];
        _totalAmount.value = 0.0;
        _itemCount.value = 0;
        _isEmpty.value = true;
      }
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 添加商品到购物车
  Future<bool> addItem(CartItem item) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      // 获取当前用户ID
      final String userId = await _getCurrentUserId();
      
      // 添加商品到购物车
      final addedItem = await _cartUseCases.addItem(userId, item);
      
      // 更新购物车状态
      final existingIndex = _items.indexWhere((i) => i.id == addedItem.id);
      if (existingIndex >= 0) {
        _items[existingIndex] = addedItem;
      } else {
        _items.add(addedItem);
      }
      
      // 重新计算总数
      _recalculateTotals();
      
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 更新购物车项数量
  Future<bool> updateItemQuantity(String itemId, int quantity) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      // 获取当前用户ID
      final String userId = await _getCurrentUserId();
      
      // 更新数量
      final updatedItem = await _cartUseCases.updateItemQuantity(userId, itemId, quantity);
      
      // 如果数量为0，移除项
      if (quantity <= 0) {
        _items.removeWhere((item) => item.id == itemId);
      } else {
        // 更新项
        final index = _items.indexWhere((item) => item.id == itemId);
        if (index >= 0) {
          _items[index] = updatedItem;
        }
      }
      
      // 重新计算总数
      _recalculateTotals();
      
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 从购物车移除商品
  Future<bool> removeItem(String itemId) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      // 获取当前用户ID
      final String userId = await _getCurrentUserId();
      
      // 移除商品
      await _cartUseCases.removeItem(userId, itemId);
      
      // 更新本地状态
      _items.removeWhere((item) => item.id == itemId);
      
      // 重新计算总数
      _recalculateTotals();
      
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 清空购物车
  Future<bool> clearCart() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      // 获取当前用户ID
      final String userId = await _getCurrentUserId();
      
      // 清空购物车
      await _cartUseCases.clearCart(userId);
      
      // 更新本地状态
      _items.clear();
      _recalculateTotals();
      
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 应用优惠码
  Future<bool> applyCoupon(String couponCode) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      // 获取当前用户ID
      final String userId = await _getCurrentUserId();
      
      // 应用优惠码
      final updatedCart = await _cartUseCases.applyCoupon(userId, couponCode);
      
      // 更新购物车状态
      _items.value = updatedCart.items;
      _totalAmount.value = updatedCart.totalAmount;
      
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 移除优惠码
  Future<bool> removeCoupon() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      // 获取当前用户ID
      final String userId = await _getCurrentUserId();
      
      // 移除优惠码
      final updatedCart = await _cartUseCases.removeCoupon(userId);
      
      // 更新购物车状态
      _items.value = updatedCart.items;
      _totalAmount.value = updatedCart.totalAmount;
      
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 合并购物车（登录后）
  Future<bool> mergeCart() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      // 获取当前用户ID和临时购物车ID
      final String userId = await _getCurrentUserId();
      final String tempCartId = await _getTempCartId();
      
      if (tempCartId.isEmpty) {
        return true; // 没有临时购物车需要合并
      }
      
      // 合并购物车
      final updatedCart = await _cartUseCases.mergeCart(userId, tempCartId);
      
      // 更新购物车状态
      _items.value = updatedCart.items;
      _totalAmount.value = updatedCart.totalAmount;
      _itemCount.value = updatedCart.itemCount;
      _isEmpty.value = updatedCart.isEmpty;
      
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// 重新计算总数
  void _recalculateTotals() {
    _totalAmount.value = _items.fold(0.0, (sum, item) => sum + item.totalPrice);
    _itemCount.value = _items.fold(0, (count, item) => count + item.quantity);
    _isEmpty.value = _items.isEmpty;
  }
  
  /// 获取当前用户ID
  Future<String> _getCurrentUserId() async {
    // 这里应该从认证服务获取当前用户ID
    // 临时使用硬编码的用户ID
    return 'user_123';
  }
  
  /// 获取临时购物车ID
  Future<String> _getTempCartId() async {
    // 这里应该从本地存储获取临时购物车ID
    // 临时返回空字符串
    return '';
  }
  
  /// 刷新购物车
  Future<void> refreshData() async {
    await _loadCart();
  }
  
  /// 刷新购物车（别名）
  Future<void> refreshCart() async {
    await _loadCart();
  }
  
  /// 切换编辑模式
  void toggleEditMode() {
    _isEditMode.value = !_isEditMode.value;
    
    // 退出编辑模式时，清除选择
    if (!_isEditMode.value) {
      _selectedItems.clear();
    }
  }
  
  /// 切换商品选择
  void toggleItemSelection(String itemId) {
    if (_selectedItems.contains(itemId)) {
      _selectedItems.remove(itemId);
    } else {
      _selectedItems.add(itemId);
    }
  }
  
  /// 全选/取消全选
  void toggleSelectAll(bool? value) {
    if (value == true) {
      // 全选
      _selectedItems.clear();
      _selectedItems.addAll(_items.map((item) => item.id));
    } else {
      // 取消全选
      _selectedItems.clear();
    }
  }
  
  /// 加载更多（分页）
  void loadMore() {
    // TODO: 实现分页加载
    // 这里可以实现分页逻辑
  }
}