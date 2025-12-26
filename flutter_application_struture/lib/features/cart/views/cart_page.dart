import 'package:flutter/material.dart';
import 'package:flutter_application_struture/features/cart/controllers/cart_controller.dart';
import 'package:flutter_application_struture/features/cart/views/cart_item_widget.dart';
import 'package:flutter_application_struture/features/cart/views/cart_bottom_sheet.dart';
import 'package:flutter_application_struture/features/cart/views/cart_empty_state.dart';
import 'package:flutter_application_struture/core/base/base_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: CartController(cartUseCases: Get.find()),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('购物车'),
            actions: [
              // 编辑/完成按钮
              Obx(() {
                return TextButton(
                  onPressed: controller.toggleEditMode,
                  child: Text(
                    controller.isEditMode ? '完成' : '编辑',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }),
              // 清空购物车按钮
              Obx(() {
                return IconButton(
                  onPressed: controller.items.isNotEmpty
                      ? () => _showClearCartDialog(context, controller)
                      : null,
                  icon: const Icon(Icons.delete_sweep),
                );
              }),
            ],
          ),
          body: _buildBody(controller),
          bottomNavigationBar: Obx(() {
            if (controller.items.isEmpty) {
              return const SizedBox.shrink();
            }
            return CartBottomSheet(controller: controller);
          }),
        );
      },
    );
  }

  Widget _buildBody(CartController controller) {
    // 加载状态
    if (controller.isLoading) {
      return const CartShimmer();
    }
    
    // 错误状态
    if (controller.error.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ErrorRetryView(
            error: controller.error,
            onRetry: controller.refreshData,
          ),
        ],
      );
    }
    
    // 空状态
    if (controller.isEmpty) {
      return const CartEmptyState();
    }
    
    // 成功状态
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: CustomScrollView(
        slivers: [
          // 购物车商品列表
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == controller.items.length) {
                  if (controller.canLoadMore) {
                    controller.loadMore();
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final item = controller.items[index];
                return CartItemWidget(
                  item: item,
                  isEditMode: controller.isEditMode,
                  onQuantityChanged: (quantity) =>
                      controller.updateItemQuantity(item.id, quantity),
                  onRemove: () => controller.removeItem(item.id),
                  onSelect: () => controller.toggleItemSelection(item.id),
                  isSelected: controller.selectedItems.contains(item.id),
                );
              },
              childCount:
                  controller.items.length + (controller.canLoadMore ? 1 : 0),
            ),
          ),
          
          // 优惠信息
          if (controller.appliedCoupon.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildCouponInfo(controller),
            ),
          
          // 优惠码输入
          SliverToBoxAdapter(
            child: _buildCouponInput(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponInfo(CartController controller) {
    final coupon = controller.appliedCoupon;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '已应用优惠码',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  coupon,
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: controller.removeCoupon,
            child: const Text('移除'),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponInput(CartController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.couponController,
              decoration: const InputDecoration(
                hintText: '输入优惠码',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => controller.applyCoupon(
              controller.couponController.text.trim(),
            ),
            child: const Text('应用'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('清空购物车'),
        content: const Text('确定要清空购物车吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearCart();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

/// 购物车加载骨架屏
class CartShimmer extends StatelessWidget {
  const CartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                      Container(
                        height: 12,
                        color: Colors.grey[300],
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 错误重试视图
class ErrorRetryView extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  const ErrorRetryView({
    super.key,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '加载失败',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
          ],
        ),
      ),
    );
  }
}