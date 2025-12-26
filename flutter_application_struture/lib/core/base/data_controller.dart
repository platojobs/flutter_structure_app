// lib/core/base/data_controller.dart
import 'package:flutter_application_struture/core/base/base_controller.dart';
import 'package:flutter_application_struture/core/config/controller_config.dart';
import 'package:flutter_application_struture/core/mixins/loading_mixin.dart';
import 'package:flutter_application_struture/core/mixins/message_mixin.dart';
import 'package:flutter_application_struture/core/mixins/validation_mixin.dart';
import 'package:get/get.dart';

/// 泛型数据控制器（带分页、缓存、状态管理）
abstract class DataController<T> extends BaseController<T> 
    with LoadingMixin, MessageMixin, ValidationMixin {
  
  /// 分页状态
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalItems = 0.obs;
  final canLoadMore = true.obs;
  final isLoadingMore = false.obs;
  
  /// 筛选状态
  final sortBy = Rx<String>('id');
  final sortOrder = Rx<SortOrder>(SortOrder.desc);
  final filters = <String, dynamic>{}.obs;
  final searchKeyword = Rx<String>('');
  
  /// 选中状态
  final selectedItems = <T>[].obs;
  final isSelectMode = false.obs;
  
  /// 缓存键
  String? cacheKey;
  
  DataController({
    ControllerConfig? config,
    this.cacheKey,
  }) : super(config: config) {
    // 自动配置混入
    if (config?.enableLoading == true) {
      configLoading();
    }
  }
  
  /// 加载数据（抽象方法）
  Future<List<T>> loadData({int page = 1, int limit = 20});
  
  /// 刷新数据
  Future<void> refreshData() async {
    await safeExecute<List<T>>(
      action: () async {
        final data = await loadData(page: 1);
        
        dataList.assignAll(data);
        currentPage.value = 1;
        canLoadMore.value = data.length >= 20;
        
        // 缓存数据
        if (config.enableCache && cacheKey != null) {
          await _cacheData(data);
        }
        
        return data;
      },
      loadingText: '刷新中...',
      successText: '刷新成功',
    );
  }
  
  /// 加载更多
  Future<void> loadMore() async {
    if (!canLoadMore.value || isLoadingMore.value) return;
    
    isLoadingMore.value = true;
    
    try {
      final nextPage = currentPage.value + 1;
      final data = await loadData(page: nextPage);
      
      if (data.isNotEmpty) {
        dataList.addAll(data);
        currentPage.value = nextPage;
        canLoadMore.value = data.length >= 20;
      } else {
        canLoadMore.value = false;
      }
    } catch (e) {
      showError('加载失败: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }
  
  /// 搜索
  Future<void> search(String keyword) async {
    searchKeyword.value = keyword;
    filters['keyword'] = keyword;
    await refreshData();
  }
  
  /// 重置筛选
  void resetFilters() {
    filters.clear();
    sortBy.value = 'id';
    sortOrder.value = SortOrder.desc;
    searchKeyword.value = '';
    refreshData();
  }
  
  /// 切换选择模式
  void toggleSelectMode() {
    isSelectMode.value = !isSelectMode.value;
    if (!isSelectMode.value) {
      selectedItems.clear();
    }
  }
  
  /// 切换选择项
  void toggleSelection(T item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    update(['selection']);
  }
  
  /// 全选/全不选
  void toggleSelectAll() {
    if (selectedItems.length == dataList.length) {
      selectedItems.clear();
    } else {
      selectedItems.assignAll(dataList);
    }
    update(['selection']);
  }
  
  /// 获取选中数量
  int get selectedCount => selectedItems.length;
  
  /// 是否全选
  bool get isAllSelected => selectedItems.length == dataList.length;
  
  /// 私有方法
  Future<void> _cacheData(List<T> data) async {
    // 实现缓存逻辑
  }
}

enum SortOrder { asc, desc }