import 'package:flutter/material.dart';
import 'package:flutter_application_struture/core/base/base_controller.dart';
import 'package:flutter_application_struture/core/config/controller_config.dart';
import 'package:flutter_application_struture/features/product/controllers/product_controller.dart';
import 'package:flutter_application_struture/features/product/views/common_widgets.dart';
import 'package:flutter_application_struture/features/product/views/product_item.dart';
import 'package:flutter_application_struture/features/product/views/dialogs.dart';
import 'package:flutter_application_struture/features/product/services/product_service.dart';
import 'package:flutter_application_struture/features/product/models/product.dart';
import 'package:get/get.dart';
import 'package:flutter_application_struture/domain/entities/product_entity.dart';

class ProductListPage extends StatelessWidget {
  final String? categoryId;

  const ProductListPage({this.categoryId, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      init: ProductController(
        categoryId: categoryId,
        config: ControllerConfig(
          enableLoading: true,
          enableAutoLoading: true,
          enableMessages: true,
          enableErrorDialog: true,
        ),
      ),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('商品列表'),
            actions: [
              // 搜索按钮
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearchDialog(context, controller),
              ),
              // 筛选按钮
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(context, controller),
              ),
            ],
          ),
          body: _buildBody(controller),
          floatingActionButton: Obx(() {
            if (controller.isSelectMode) {
              return _buildSelectionActions(controller);
            }
            return SizedBox.shrink();
          }),
        );
      },
    );
  }

  Widget _buildBody(ProductController controller) {
    return StateWidget<ProductController>(
      controller: controller,
      onLoading: () => const ProductListShimmer(),
      onError: (error) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ErrorRetryView(
            error: error,
            onRetry: controller.refreshData,
          ),
        ],
      ),
      onEmpty: () => const EmptyStateView(
        icon: Icons.inventory,
        title: '暂无商品',
        subtitle: '暂时没有找到相关商品',
      ),
      onSuccess: (ctrl) => RefreshIndicator(
        onRefresh: ctrl.refreshData,
        child: CustomScrollView(
          slivers: [
            // 商品网格
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == ctrl.dataList.length) {
                    if (ctrl.canLoadMore) {
                      ctrl.loadMore();
                      return const LoadingMoreItem();
                    }
                    return const SizedBox.shrink();
                  }

                  final product = ctrl.dataList[index];
                  
                  return Obx(
                    () => ProductItem(
                      product: _createProductItem(product),
                      onTap: () => _openProductDetail(product),
                      onAddToCart: () => ctrl.addToCart(product),
                      onToggleFavorite: () => ctrl.toggleFavorite(product),
                      isSelectMode: ctrl.isSelectMode,
                      isSelected: ctrl.selectedItems.contains(product),
                      onSelect: () => ctrl.toggleSelection(product),
                    ),
                  );
                },
                childCount:
                    ctrl.dataList.length + (ctrl.canLoadMore ? 1 : 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionActions(ProductController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'delete',
          onPressed: () => _deleteSelected(controller),
          backgroundColor: Colors.red,
          child: const Icon(Icons.delete),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'share',
          onPressed: () => _shareSelected(controller),
          backgroundColor: Colors.blue,
          child: const Icon(Icons.share),
        ),
      ],
    );
  }

  void _showSearchDialog(BuildContext context, ProductController controller) {
    Get.dialog(
      SearchDialog(
        onSearch: (keyword) => controller.search(keyword),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, ProductController controller) {
    Get.dialog(
      FilterDialog(
        onPriceRangeChanged: (minPrice, maxPrice) {
          controller.filterByPriceRange(minPrice, maxPrice);
        },
        onRatingChanged: (minRating) {
          controller.filterByRating(minRating);
        },
      ),
    );
  }

  void _openProductDetail(ProductEntity product) {
    // 导航到商品详情页面
    Get.toNamed('/product/detail', arguments: {'id': product.id});
  }

  // 创建Product对象用于ProductItem显示
  Product _createProductItem(ProductEntity entity) {
    return Product(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      salePrice: entity.originalPrice,
      categoryId: entity.category.value,
      images: entity.imageUrls.isNotEmpty ? entity.imageUrls : [entity.imageUrl ?? ''],
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      stock: entity.stockQuantity,
      isFavorite: entity.isFavorite,
      createdAt: entity.createdAt ?? DateTime.now(),
    );
  }

  void _deleteSelected(ProductController controller) async {
    if (controller.selectedItems.isEmpty) {
      controller.showError('请先选择商品');
      return;
    }

    // 确认删除操作
    await Get.dialog(
      AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除选中的${controller.selectedCount}个商品吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _performDelete(controller);
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete(ProductController controller) async {
    try {
      // 执行删除逻辑
      final productService = Get.find<ProductService>();
      final ids = controller.selectedItems.map((p) => p.id).toList();
      await productService.deleteMultiple(ids);

      // 更新列表
      controller.dataList.removeWhere(
        (p) => controller.selectedItems.contains(p),
      );
      controller.selectedItems.clear();
      controller.toggleSelectMode();
      controller.showSuccess('删除成功');
    } catch (e) {
      controller.showError('删除失败');
    }
  }

  Future<void> _shareSelected(ProductController controller) async {
    if (controller.selectedItems.isEmpty) {
      controller.showError('请先选择商品');
      return;
    }

    final productService = Get.find<ProductService>();
    for (final product in controller.selectedItems) {
      await productService.share(product.id);
    }

    controller.showSuccess('已分享${controller.selectedCount}个商品');
    controller.selectedItems.clear();
    controller.toggleSelectMode();
  }
}

/// 通用状态组件
class StateWidget<T extends BaseController> extends StatelessWidget {
  final T controller;
  final Widget Function()? onLoading;
  final Widget Function(String error)? onError;
  final Widget Function(T controller) onSuccess;
  final Widget Function()? onEmpty;
  final Widget Function()? onIdle;

  const StateWidget({
    super.key,
    required this.controller,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onEmpty,
    this.onIdle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.viewState) {
        case ViewState.loading:
          return onLoading?.call() ??
              const Center(child: CircularProgressIndicator());
        case ViewState.success:
          return onSuccess(controller);
        case ViewState.failed:
          return onError?.call(controller.errorMessage ?? '未知错误') ??
              ErrorView(error: controller.errorMessage);
        case ViewState.empty:
          return onEmpty?.call() ?? const EmptyView();
        case ViewState.idle:
          return onIdle?.call() ?? const SizedBox();
      }
    });
  }
}