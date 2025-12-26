import 'package:flutter/material.dart';

/// 购物车空状态组件
class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 空购物车图标
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey.shade300,
            ),
            
            const SizedBox(height: 24),
            
            // 标题
            Text(
              '购物车空空如也',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 副标题
            Text(
              '快去挑选心仪的商品吧',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 去购物按钮
            ElevatedButton.icon(
              onPressed: () => _onGoShoppingPressed(context),
              icon: const Icon(Icons.shopping_bag),
              label: const Text('去购物'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 推荐商品按钮
            TextButton.icon(
              onPressed: () => _onViewRecommendedPressed(context),
              icon: const Icon(Icons.recommend),
              label: const Text('查看推荐商品'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.red.shade300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onGoShoppingPressed(BuildContext context) {
    // TODO: 跳转到商品列表页面
    // 可以使用 Navigator.popUntil() 返回到主页面
    // 或者 Get.toNamed() 跳转到商品列表
    print('跳转到商品列表页面');
  }

  void _onViewRecommendedPressed(BuildContext context) {
    // TODO: 跳转到推荐商品页面
    print('跳转到推荐商品页面');
  }
}