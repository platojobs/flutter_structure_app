/// 基础仓库接口，定义通用仓库方法
abstract class BaseRepository {
  /// 初始化仓库资源
  Future<void> init() async {}

  /// 释放资源
  void dispose() {}
}
