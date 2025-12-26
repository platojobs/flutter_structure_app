import 'package:flutter/material.dart';
import 'package:flutter_application_struture/domain/entities/cart_entity.dart';

/// 购物车商品项组件
class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final bool isEditMode;
  final Function(int quantity) onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback onSelect;
  final bool isSelected;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.isEditMode,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 选择框（编辑模式下显示）
              if (isEditMode)
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onSelect(),
                  activeColor: Theme.of(context).primaryColor,
                )
              else
                const SizedBox(width: 24),
              
              const SizedBox(width: 12),
              
              // 商品图片
              _buildProductImage(),
              
              const SizedBox(width: 12),
              
              // 商品信息
              Expanded(
                child: _buildProductInfo(context),
              ),
              
              const SizedBox(width: 8),
              
              // 数量控制和删除按钮
              _buildQuantityControls(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey.shade400,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 商品名称
        Text(
          item.productName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // 商品规格信息
        if (item.options != null && item.options!.isNotEmpty) ...[
          Text(
            item.options!.values.join(', '),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
        ],
        
        // 价格信息
        Row(
          children: [
            Text(
              '¥${item.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 数量调整按钮（编辑模式下显示）
        if (isEditMode) ...[
          // 增加按钮
          IconButton(
            onPressed: () {
              // 暂时不检查库存，可以根据实际需求添加库存检查
              onQuantityChanged(item.quantity + 1);
            },
            icon: const Icon(Icons.add_circle_outline),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
            iconSize: 20,
            color: Theme.of(context).primaryColor,
          ),
          
          const SizedBox(height: 4),
          
          // 数量显示
          Text(
            '${item.quantity}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // 减少按钮
          IconButton(
            onPressed: item.quantity > 1 
                ? () => onQuantityChanged(item.quantity - 1)
                : null,
            icon: const Icon(Icons.remove_circle_outline),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
            iconSize: 20,
            color: item.quantity > 1 
                ? Theme.of(context).primaryColor 
                : Colors.grey.shade400,
          ),
          
          const SizedBox(height: 8),
          
          // 删除按钮
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
            iconSize: 20,
          ),
        ] else
          // 普通模式显示总价
          Column(
            children: [
              Text(
                '¥${item.totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'x${item.quantity}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
      ],
    );
  }
}