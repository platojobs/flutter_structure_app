import 'package:get/get.dart';

/// 商品服务
class ProductService extends GetxService {
  /// 删除商品
  Future<bool> delete(String productId) async {
    // 模拟删除 API 调用
    await Future.delayed(const Duration(milliseconds: 300));
    print('删除商品: $productId');
    return true;
  }

  /// 批量删除商品
  Future<bool> deleteMultiple(List<String> productIds) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('批量删除商品: $productIds');
    return true;
  }

  /// 分享商品
  Future<bool> share(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    print('分享商品: $productId');
    return true;
  }
}
