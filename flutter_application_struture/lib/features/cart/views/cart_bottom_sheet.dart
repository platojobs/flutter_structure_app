import 'package:flutter/material.dart';
import 'package:flutter_application_struture/features/cart/controllers/cart_controller.dart';

/// 购物车底部结算面板
class CartBottomSheet extends StatelessWidget {
  final CartController controller;

  const CartBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 总价信息
            _buildTotalInfo(),
            
            const SizedBox(height: 16),
            
            // 结算按钮
            _buildCheckoutButton(),
            
            const SizedBox(height: 8),
            
            // 继续购物按钮
            _buildContinueShoppingButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '共${controller.itemCount}件商品',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: '合计：',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '¥${controller.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        // 全选/取消全选按钮
        Row(
          children: [
            Checkbox(
              value: controller.isAllSelected,
              onChanged: controller.toggleSelectAll,
              activeColor: Colors.red,
            ),
            const Text(
              '全选',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: controller.canCheckout
            ? () => _onCheckoutPressed()
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          '结算(${controller.selectedItems.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueShoppingButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextButton(
        onPressed: () => _onContinueShoppingPressed(context),
        child: const Text(
          '继续购物',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _onCheckoutPressed() {
    if (controller.selectedItems.isEmpty) {
      // 可以显示提示消息
      return;
    }
    
    // TODO: 跳转到结算页面
    // 可以使用 Get.toNamed() 导航到结算页面
  }

  void _onContinueShoppingPressed(BuildContext context) {
    // 返回到商品列表页面
    Navigator.of(context).pop();
  }
}