import 'package:get/get.dart';

/// 通知服务
class NotificationService extends GetxService {
  final _notificationHistory = <String>[].obs;

  List<String> get notificationHistory => _notificationHistory;

  /// 发送通知
  void sendNotification(String title, String message) {
    final notification = '$title: $message';
    _notificationHistory.add(notification);
    print('📢 通知: $notification');
  }

  /// 清空通知历史
  void clearHistory() {
    _notificationHistory.clear();
  }

  /// 获取最后一条通知
  String? getLastNotification() {
    return _notificationHistory.isNotEmpty ? _notificationHistory.last : null;
  }
}
