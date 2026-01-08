import 'package:get/get.dart';
import 'package:flutter_application_struture/core/config/controller_config.dart';
import 'package:flutter_application_struture/core/utils/logger.dart';

/// 视图状态
enum ViewState { idle, loading, success, failed, empty }

/// 响应式控制器基类
abstract class BaseController<T> extends GetxController {
  final ControllerConfig config;
  
  /// 状态管理
  final _viewState = ViewState.idle.obs;
  ViewState get viewState => _viewState.value;
  
  /// 错误信息
  final _errorMessage = Rx<String?>(null);
  String? get errorMessage => _errorMessage.value;
  
  /// 数据
  final _data = Rx<T?>(null);
  T? get data => _data.value;
  
  /// 列表数据
  final _dataList = <T>[].obs;
  List<T> get dataList => _dataList;
  
  /// 便捷访问器
  bool get isLoading => viewState == ViewState.loading;
  bool get isSuccess => viewState == ViewState.success;
  bool get isFailed => viewState == ViewState.failed;
  bool get isEmpty => viewState == ViewState.empty;
  bool get hasData => data != null || dataList.isNotEmpty;
  
  BaseController({ControllerConfig? config}) : config = config ?? ControllerConfig.fromEnvironment();
  
  /// 安全执行（核心方法）
  Future<R?> safeExecute<R>({
    required Future<R> Function() action,
    bool? showLoading,
    String? loadingText,
    bool? showSuccess,
    String? successText,
    bool? showError,
    String? errorText,
    bool updateState = true,
    Function(R result)? onSuccess,
    Function(dynamic error)? onError,
    Function()? onFinally,
  }) async {
    final bool shouldShowLoading = showLoading ?? 
        (config.enableLoading && config.enableAutoLoading);
    final bool shouldShowSuccess = showSuccess ?? config.enableMessages;
    final bool shouldShowError = showError ?? config.enableErrorDialog;
    
    try {
      // 更新状态
      if (updateState) _setState(ViewState.loading);
      
      // 显示加载
      if (shouldShowLoading && _showLoading != null) {
        _showLoading!(loadingText);
      }
      
      // 执行操作
      final result = await action();
      
      // 成功回调
      if (updateState) _setState(ViewState.success);
      onSuccess?.call(result);
      
      // 显示成功提示
      if (shouldShowLoading && _dismissLoading != null) {
        _dismissLoading!();
      }
      
      if (shouldShowSuccess && successText != null && _showSuccess != null) {
        _showSuccess!(successText);
      }
      
      return result;
      
    } catch (e, stackTrace) {
      // 错误处理
      final errorMsg = _parseError(e);
      if (updateState) _setState(ViewState.failed, error: errorMsg);
      onError?.call(e);
      
      // 显示错误
      if (shouldShowLoading && _dismissLoading != null) {
        _dismissLoading!();
      }
      
      if (shouldShowError && _showError != null) {
        _showError!(errorText ?? errorMsg);
      }
      
      // 记录错误
      _logError(e, stackTrace);
      return null;
      
    } finally {
      onFinally?.call();
    }
  }
  
  /// 静默执行（无UI反馈）
  Future<R?> executeSilently<R>(Future<R> Function() action) async {
    return await safeExecute(
      action: action,
      showLoading: false,
      showSuccess: false,
      showError: false,
      updateState: false,
    );
  }
  
  /// 带进度条的执行
  Future<R?> executeWithProgress<R>({
    required Future<R> Function(void Function(double) onProgress) action,
    String? loadingText,
  }) async {
    if (_showProgress == null) return null;
    
    return await safeExecute(
      action: () async {
        _showProgress!(0.0, status: loadingText);
        
        final result = await action((p) {
          _showProgress!(p, status: '$loadingText ${(p * 100).toInt()}%');
        });
        
        return result;
      },
      showLoading: false, // 手动控制进度条
    );
  }
  
  /// 设置数据
  void setData(T? newData) => _data.value = newData;
  void setDataList(List<T> newList) => _dataList.assignAll(newList);
  
  /// 添加数据
  void addData(T item) => _dataList.add(item);
  void addAllData(List<T> items) => _dataList.addAll(items);
  
  /// 更新数据
  void updateData(T Function(T) update) {
    if (_data.value != null) {
      _data.value = update(_data.value!);
    }
  }
  
  /// 清理数据
  void clearData() {
    _data.value = null;
    _dataList.clear();
  }
  
  /// 重置状态
  void resetState() {
    _viewState.value = ViewState.idle;
    _errorMessage.value = null;
  }
  
  /// 生命周期
  @override
  void onClose() {
    resetState();
    super.onClose();
  }
  
  // Mixin 回调方法（由混入类实现）
  void Function(String? text)? _showLoading;
  void Function()? _dismissLoading;
  void Function(String message)? _showSuccess;
  void Function(String message)? _showError;
  void Function(double progress, {String? status})? _showProgress;
  
  // 设置回调
  void setLoadingCallbacks({
    void Function(String? text)? showLoading,
    void Function()? dismissLoading,
    void Function(String message)? showSuccess,
    void Function(String message)? showError,
    void Function(double progress, {String? status})? showProgress,
  }) {
    _showLoading = showLoading;
    _dismissLoading = dismissLoading;
    _showSuccess = showSuccess;
    _showError = showError;
    _showProgress = showProgress;
  }
  
  // 私有方法
  void _setState(ViewState state, {String? error}) {
    _viewState.value = state;
    _errorMessage.value = error;
    update();
  }
  
  String _parseError(dynamic error) {
    if (error is String) return error;
    if (error is Map<String, dynamic>) {
      return error['message'] ?? error.toString();
    }
    if (error is Exception) return error.toString();
    return '未知错误';
  }
  
  void _logError(dynamic error, StackTrace stackTrace) {
    // 使用 AppLogger 记录错误
    AppLogger.error('Controller Error', error: error, stackTrace: stackTrace);
  }
}