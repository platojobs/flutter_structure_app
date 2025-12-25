import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 搜索对话框
class SearchDialog extends StatefulWidget {
  final Function(String keyword)? onSearch;

  const SearchDialog({super.key, this.onSearch});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('搜索商品'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: '输入商品名称',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSearch?.call(_controller.text);
            Get.back();
          },
          child: const Text('搜索'),
        ),
      ],
    );
  }
}

/// 筛选对话框
class FilterDialog extends StatefulWidget {
  final Function(double minPrice, double maxPrice)? onPriceRangeChanged;
  final Function(double minRating)? onRatingChanged;

  const FilterDialog({
    super.key,
    this.onPriceRangeChanged,
    this.onRatingChanged,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late RangeValues _priceRange;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _priceRange = const RangeValues(0, 10000);
    _rating = 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('筛选商品'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 价格范围
          const Text('价格范围'),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 10000,
            onChanged: (RangeValues values) {
              setState(() => _priceRange = values);
            },
          ),
          Text('¥${_priceRange.start.toInt()} - ¥${_priceRange.end.toInt()}'),
          const SizedBox(height: 20),
          // 最低评分
          const Text('最低评分'),
          Slider(
            value: _rating,
            min: 0,
            max: 5,
            divisions: 5,
            label: _rating.toStringAsFixed(1),
            onChanged: (value) {
              setState(() => _rating = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onPriceRangeChanged?.call(
              _priceRange.start.toDouble(),
              _priceRange.end.toDouble(),
            );
            widget.onRatingChanged?.call(_rating);
            Get.back();
          },
          child: const Text('应用'),
        ),
      ],
    );
  }
}
