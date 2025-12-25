import 'package:get/get.dart';

/// 数据分析服务
class AnalyticsService extends GetxService {
  final _events = <String>[].obs;

  List<String> get events => _events;

  /// 记录事件
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    final event = '$eventName ${parameters ?? {}}';
    _events.add(event);
    print('📊 事件追踪: $event');
  }

  /// 获取事件数量
  int get eventCount => _events.length;

  /// 清空事件
  void clearEvents() {
    _events.clear();
  }
}
