import 'package:get/get.dart';

/// 商品服务
class ProductService extends GetxService {
  /// 删除商品
  Future<bool> delete(String productId) async {
    // 模拟删除 API 调用
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  /// 批量删除商品
  Future<bool> deleteMultiple(List<String> productIds) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 分享商品
  Future<bool> share(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
