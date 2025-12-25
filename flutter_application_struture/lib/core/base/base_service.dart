/// 基础服务类，提供生命周期钩子与公共行为抽象
abstract class BaseService {
  /// 初始化服务（例如建立连接、预加载数据）
  Future<void> init() async {}

  /// 释放资源
  void dispose() {}
}
