import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的订单'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '全部'),
            Tab(text: '待付款'),
            Tab(text: '待发货'),
            Tab(text: '待收货'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _OrderListTab(status: 'all'),
          _OrderListTab(status: 'pending'),
          _OrderListTab(status: 'processing'),
          _OrderListTab(status: 'shipped'),
        ],
      ),
    );
  }
}

class _OrderListTab extends StatelessWidget {
  final String status;
  
  const _OrderListTab({required this.status});

  @override
  Widget build(BuildContext context) {
    // 模拟订单数据
    final mockOrders = _getMockOrders(status);
    
    if (mockOrders.isEmpty) {
      return _buildEmptyState(status);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(context, mockOrders[index]);
      },
    );
  }
  
  Widget _buildEmptyState(String status) {
    String message = '';
    IconData icon = Icons.shopping_bag;
    
    switch (status) {
      case 'pending':
        message = '暂无待付款订单';
        icon = Icons.payment;
        break;
      case 'processing':
        message = '暂无待发货订单';
        icon = Icons.inventory_2;
        break;
      case 'shipped':
        message = '暂无待收货订单';
        icon = Icons.local_shipping;
        break;
      default:
        message = '暂无订单';
        icon = Icons.shopping_bag;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单头部信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '订单号：${order['orderNo']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  order['statusText'],
                  style: TextStyle(
                    fontSize: 14,
                    color: _getStatusColor(order['status']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 订单商品列表
            ...order['items'].map<Widget>((item) => _buildOrderItem(item)).toList(),
            
            const SizedBox(height: 12),
            
            // 订单总价和操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '合计：¥${order['totalAmount']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Row(
                  children: _buildActionButtons(order['status']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['imageUrl'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '规格：${item['spec']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '¥${item['price']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'x${item['quantity']}',
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
    );
  }
  
  List<Widget> _buildActionButtons(String status) {
    switch (status) {
      case 'pending':
        return [
          OutlinedButton(
            onPressed: () {},
            child: const Text('取消订单'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('去付款'),
          ),
        ];
      case 'processing':
        return [
          OutlinedButton(
            onPressed: () {},
            child: const Text('查看物流'),
          ),
        ];
      case 'shipped':
        return [
          OutlinedButton(
            onPressed: () {},
            child: const Text('查看物流'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('确认收货'),
          ),
        ];
      case 'completed':
        return [
          OutlinedButton(
            onPressed: () {},
            child: const Text('再次购买'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('评价'),
          ),
        ];
      default:
        return [];
    }
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  List<Map<String, dynamic>> _getMockOrders(String status) {
    final allOrders = [
      {
        'orderNo': '20241226001',
        'status': 'pending',
        'statusText': '待付款',
        'totalAmount': '299.00',
        'createTime': '2024-12-26 10:30',
        'items': [
          {
            'name': 'iPhone 15 Pro',
            'spec': '256GB 深空黑色',
            'price': '8999.00',
            'quantity': 1,
            'imageUrl': 'https://via.placeholder.com/300x300?text=iPhone+15+Pro',
          },
          {
            'name': 'MagSafe 充电器',
            'spec': '白色',
            'price': '299.00',
            'quantity': 1,
            'imageUrl': 'https://via.placeholder.com/300x300?text=MagSafe',
          },
        ],
      },
      {
        'orderNo': '20241225002',
        'status': 'processing',
        'statusText': '待发货',
        'totalAmount': '1599.00',
        'createTime': '2024-12-25 14:20',
        'items': [
          {
            'name': 'MacBook Air M2',
            'spec': '13英寸 8GB+256GB',
            'price': '7999.00',
            'quantity': 1,
            'imageUrl': 'https://via.placeholder.com/300x300?text=MacBook+Air',
          },
        ],
      },
      {
        'orderNo': '20241224003',
        'status': 'shipped',
        'statusText': '待收货',
        'totalAmount': '99.00',
        'createTime': '2024-12-24 16:45',
        'items': [
          {
            'name': 'AirPods Pro',
            'spec': '第二代',
            'price': '1999.00',
            'quantity': 1,
            'imageUrl': 'https://via.placeholder.com/300x300?text=AirPods+Pro',
          },
        ],
      },
    ];
    
    if (status == 'all') {
      return allOrders;
    }
    
    return allOrders.where((order) => order['status'] == status).toList();
  }
}