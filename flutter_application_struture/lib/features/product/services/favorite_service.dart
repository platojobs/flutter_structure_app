import 'package:get/get.dart';

/// 收藏/喜欢服务
class FavoriteService extends GetxService {
  final _favorites = <String>[].obs;

  List<String> get favorites => _favorites;

  /// 切换收藏状态
  Future<bool> toggle(String productId, bool isFavorite) async {
    // 模拟 API 请求
    await Future.delayed(const Duration(milliseconds: 300));

    if (isFavorite) {
      if (!_favorites.contains(productId)) {
        _favorites.add(productId);
      }
    } else {
      _favorites.remove(productId);
    }

    return true;
  }

  /// 添加到收藏
  Future<bool> addFavorite(String productId) async {
    return toggle(productId, true);
  }

  /// 移除收藏
  Future<bool> removeFavorite(String productId) async {
    return toggle(productId, false);
  }

  /// 检查是否已收藏
  bool isFavorite(String productId) {
    return _favorites.contains(productId);
  }

  /// 获取收藏列表
  List<String> getFavorites() => List.from(_favorites);
}
