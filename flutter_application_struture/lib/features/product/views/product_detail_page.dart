import 'package:flutter/material.dart';
import 'package:flutter_application_struture/features/product/controllers/product_detail_controller.dart';
import 'package:flutter_application_struture/features/product/views/common_widgets.dart';
import 'package:flutter_application_struture/features/product/views/product_detail_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  final String? productId;
  
  const ProductDetailPage({
    this.productId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.product.value?.name ?? '商品详情')),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              controller.product.value?.isFavorite == true 
                  ? Icons.favorite 
                  : Icons.favorite_border,
              color: controller.product.value?.isFavorite == true 
                  ? Colors.red 
                  : null,
            )),
            onPressed: controller.toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.shareProduct,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ProductDetailShimmer();
        }

        if (controller.product.value == null) {
          return const ErrorRetryView(
            error: '商品不存在',
            onRetry: null,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGallery(controller),
                _buildProductInfo(controller),
                _buildRatingAndReviews(controller),
                _buildSpecifications(controller),
                _buildDescription(controller),
                _buildRecommendedProducts(controller),
                const SizedBox(height: 80), // 为底部操作按钮留出空间
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.product.value == null) return null;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.product.value?.canPurchase == true
                      ? controller.addToCart
                      : null,
                  icon: const Icon(Icons.shopping_cart),
                  label: Text(
                    controller.product.value?.stockStatus == StockStatus.outOfStock
                        ? '暂时缺货'
                        : controller.product.value?.canPurchase == true
                            ? '加入购物车'
                            : '暂时无法购买',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.product.value?.canPurchase == true
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.product.value?.canPurchase == true
                      ? () => _showBuyNowBottomSheet(context, controller)
                      : null,
                  child: const Text('立即购买'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageGallery(ProductDetailController controller) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: controller.product.value?.imageUrls.length ?? 0,
            onPageChanged: controller.setCurrentImageIndex,
            itemBuilder: (context, index) {
              final imageUrl = controller.product.value!.imageUrls[index];
              return GestureDetector(
                onTap: () => _openImageGallery(context, controller, index),
                child: Hero(
                  tag: 'product_image_$index',
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() => Text(
                '${controller.currentImageIndex.value + 1}/${controller.product.value?.imageUrls.length ?? 0}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )),
            ),
          ),
          if (controller.product.value?.discountPercentage != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-${controller.product.value!.discountPercentage!.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ProductDetailController controller) {
    final product = controller.product.value!;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                product.formattedPrice,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              if (product.originalPrice != null)
                Text(
                  product.formattedOriginalPrice!,
                  style: const TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(width: 8),
              if (product.discountPercentage != null)
                Text(
                  '省¥${(product.originalPrice! - product.price).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Text(
                '库存: ${product.stockQuantity}件',
                style: TextStyle(
                  color: product.stockQuantity <= 10 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingAndReviews(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '用户评价',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => _showAllReviews(context, controller),
                child: const Text('查看全部'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 这里可以添加评价列表组件
          // 暂时显示简单信息
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('用'),
              ),
              title: const Text('用户评价'),
              subtitle: const Text('暂无评价'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < 4 ? Colors.amber : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications(ProductDetailController controller) {
    final specifications = controller.product.value?.specifications;
    
    if (specifications == null || specifications.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '商品规格',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: specifications.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(entry.value.toString()),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '商品详情',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                controller.product.value!.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProducts(ProductDetailController controller) {
    if (controller.recommendedProducts.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '相关推荐',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.recommendedProducts.length,
              itemBuilder: (context, index) {
                final product = controller.recommendedProducts[index];
                return GestureDetector(
                  onTap: () => Get.toNamed(
                    '/product/detail',
                    arguments: {'id': product.id},
                  ),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              product.imageUrl ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.formattedPrice,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openImageGallery(
    BuildContext context,
    ProductDetailController controller,
    int initialIndex,
  ) {
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                final imageUrl = controller.product.value!.imageUrls[index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrl),
                  initialScale: PhotoViewComputedScale.contained,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: 'product_image_$index',
                  ),
                );
              },
              itemCount: controller.product.value!.imageUrls.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded / event.expectedBytesLoaded!,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: initialIndex,
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${initialIndex + 1}/${controller.product.value!.imageUrls.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      fullscreenDialog: true,
    );
  }

  void _showMoreOptions(BuildContext context, ProductDetailController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('收藏'),
            onTap: () {
              Navigator.pop(context);
              controller.toggleFavorite();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('分享'),
            onTap: () {
              Navigator.pop(context);
              controller.shareProduct();
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('举报'),
            onTap: () {
              Navigator.pop(context);
              // 显示举报对话框
            },
          ),
        ],
      ),
    );
  }

  void _showBuyNowBottomSheet(
    BuildContext context,
    ProductDetailController controller,
  ) {
    Get.bottomSheet(
      ProductDetailBottomSheet(
        product: controller.product.value!,
        onConfirm: controller.buyNow,
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  void _showAllReviews(BuildContext context, ProductDetailController controller) {
    // 导航到评价列表页面
    Get.toNamed('/product/reviews', arguments: {
      'productId': controller.product.value!.id,
    });
  }
}