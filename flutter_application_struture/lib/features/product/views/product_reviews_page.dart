import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_struture/features/product/views/common_widgets.dart';

class ProductReviewsPage extends StatefulWidget {
  final String productId;
  
  const ProductReviewsPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductReviewsPage> createState() => _ProductReviewsPageState();
}

class _ProductReviewsPageState extends State<ProductReviewsPage> {
  String _selectedFilter = 'all';
  final List<Map<String, dynamic>> _mockReviews = [
    {
      'id': '1',
      'userName': '用户***',
      'rating': 5,
      'date': '2024-12-20',
      'content': '商品质量很好，包装精美，物流很快，推荐购买！',
      'images': ['https://via.placeholder.com/150?text=Review1'],
      'helpful': 12,
      'reply': '感谢您的支持！',
    },
    {
      'id': '2',
      'userName': '用户***',
      'rating': 4,
      'date': '2024-12-18',
      'content': '整体不错，性价比很高，就是发货稍微慢了一点。',
      'images': [],
      'helpful': 8,
      'reply': '我们会继续优化发货速度，感谢您的反馈！',
    },
    {
      'id': '3',
      'userName': '用户***',
      'rating': 3,
      'date': '2024-12-15',
      'content': '商品还行，但是和描述有些出入，不过整体可以接受。',
      'images': ['https://via.placeholder.com/150?text=Review3', 'https://via.placeholder.com/150?text=Review4'],
      'helpful': 5,
      'reply': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户评价'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildReviewSummary(),
          const Divider(height: 1),
          Expanded(
            child: _buildReviewsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSummary() {
    final totalReviews = _mockReviews.length;
    final averageRating = _mockReviews.map((r) => r['rating']).reduce((a, b) => a + b) / totalReviews;
    final ratingDistribution = <int, int>{};
    
    for (int i = 1; i <= 5; i++) {
      ratingDistribution[i] = _mockReviews.where((r) => r['rating'] == i).length;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 平均分
          Column(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < averageRating.round() ? Colors.amber : Colors.grey,
                    size: 16,
                  );
                }),
              ),
              Text(
                '$totalReviews 条评价',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // 评分分布
          Expanded(
            child: Column(
              children: [
                for (int i = 5; i >= 1; i--) ...[
                  Row(
                    children: [
                      Text('$i 星'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: totalReviews > 0 ? ratingDistribution[i]! / totalReviews : 0,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${ratingDistribution[i] ?? 0}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    final filteredReviews = _getFilteredReviews();
    
    if (filteredReviews.isEmpty) {
      return const EmptyStateView(
        icon: Icons.rate_review,
        title: '暂无评价',
        subtitle: '还没有评价数据',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReviews.length,
      itemBuilder: (context, index) {
        return _buildReviewCard(filteredReviews[index]);
      },
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息和评分
            Row(
              children: [
                CircleAvatar(
                  child: Text(review['userName'][0]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['userName'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < review['rating'] ? Colors.amber : Colors.grey,
                              size: 16,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            review['date'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 评价内容
            Text(
              review['content'],
              style: const TextStyle(fontSize: 14),
            ),
            
            const SizedBox(height: 12),
            
            // 评价图片
            if (review['images'].isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (review['images'] as List<String>).map((imageUrl) {
                  return GestureDetector(
                    onTap: () => _showImagePreview(review['images'] as List<String>, imageUrl),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
            
            // 商家回复
            if (review['reply'].isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '商家回复',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review['reply'],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 12),
            
            // 点赞和回复
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_outlined, size: 16),
                  label: Text('有用 (${review['helpful']})'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('回复'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredReviews() {
    if (_selectedFilter == 'all') {
      return _mockReviews;
    }
    final rating = int.parse(_selectedFilter);
    return _mockReviews.where((review) => review['rating'] == rating).toList();
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '筛选评价',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...[
            {'label': '全部', 'value': 'all'},
            {'label': '5星', 'value': '5'},
            {'label': '4星', 'value': '4'},
            {'label': '3星', 'value': '3'},
            {'label': '2星', 'value': '2'},
            {'label': '1星', 'value': '1'},
          ].map((item) {
            return RadioListTile<String>(
              title: Text(item['label'] as String),
              value: item['value'] as String,
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Get.back();
              },
            );
          }),
        ],
      ),
    );
  }

  void _showImagePreview(List<String> images, String initialImage) {
    final initialIndex = images.indexOf(initialImage);
    final currentPageIndex = ValueNotifier<int>(initialIndex);
    
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) {
                currentPageIndex.value = index;
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Image.network(
                    images[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 48,
                      );
                    },
                  ),
                );
              },
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ValueListenableBuilder<int>(
                valueListenable: currentPageIndex,
                builder: (context, index, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${index + 1}/${images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      fullscreenDialog: true,
    );
  }
}