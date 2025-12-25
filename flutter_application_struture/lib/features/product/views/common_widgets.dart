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
