import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 商品列表加载骨架屏
class ProductListShimmer extends StatelessWidget {
  final int itemCount;

  const ProductListShimmer({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
              childCount: itemCount,
            ),
          ),
        ],
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error ?? '加载失败',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}

/// 空状态视图
class EmptyStateView extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;

  const EmptyStateView({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon ?? Icons.inbox, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title ?? '暂无数据',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

/// 错误视图
class ErrorView extends StatelessWidget {
  final String? error;

  const ErrorView({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error ?? '发生错误'),
    );
  }
}

/// 空视图
class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateView();
  }
}

/// 加载更多项
class LoadingMoreItem extends StatelessWidget {
  const LoadingMoreItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: CircularProgressIndicator(),
    );
  }
}

/// 产品详情加载骨架屏
class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片轮播骨架
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Container(
              color: Colors.white,
            ),
          ),
          
          // 产品信息骨架
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 32,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.6,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          
          // 评价骨架
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          
          // 规格骨架
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          
          // 详情骨架
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          
          // 推荐产品骨架
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 140,
                              width: 140,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: 120,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: 80,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
