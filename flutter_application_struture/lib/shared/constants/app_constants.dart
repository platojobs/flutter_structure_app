class AppConstants {
  AppConstants._();
  
  // 应用信息
  static const String appName = 'Flutter应用';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // API 配置
  static const String apiBaseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';
  static const int apiTimeout = 30000; // 毫秒
  
  // 缓存配置
  static const String cachePrefix = 'flutter_app_cache_';
  static const int defaultCacheExpiryMinutes = 30;
  static const int maxCacheSizeMB = 100;
  
  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int minPageSize = 5;
  
  // 文件上传配置
  static const int maxFileSizeMB = 10;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // 验证配置
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  
  // 日期格式
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'yyyy年MM月dd日';
  static const String displayTimeFormat = 'HH:mm';
  static const String displayDateTimeFormat = 'yyyy年MM月dd日 HH:mm';
  
  // 本地存储键名
  static const String storageUserToken = 'user_token';
  static const String storageUserInfo = 'user_info';
  static const String storageThemeMode = 'theme_mode';
  static const String storageLanguage = 'language';
  static const String storageFirstLaunch = 'first_launch';
  static const String storageOnboardingCompleted = 'onboarding_completed';
  
  // 动画时长
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // 网络状态
  static const int networkTimeoutSeconds = 30;
  static const int networkRetryCount = 3;
  
  // UI 尺寸配置
  static const double appBarHeight = 56.0;
  static const double bottomNavigationBarHeight = 56.0;
  static const double drawerWidth = 280.0;
  static const double minTouchTargetSize = 48.0;
  
  // 文本长度限制
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxCommentLength = 300;
  static const int maxSearchQueryLength = 50;
  
  // 分页参数
  static const int initialPage = 1;
  static const int prefetchDistance = 5;
  
  // 图片配置
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const int thumbnailWidth = 200;
  static const int thumbnailHeight = 200;
  static const int qualityCompression = 80;
  
  // 消息类型
  static const String messageTypeSuccess = 'success';
  static const String messageTypeError = 'error';
  static const String messageTypeWarning = 'warning';
  static const String messageTypeInfo = 'info';
  
  // 主题配置
  static const String themeModeLight = 'light';
  static const String themeModeDark = 'dark';
  static const String themeModeSystem = 'system';
  
  // 语言配置
  static const String languageChinese = 'zh';
  static const String languageEnglish = 'en';
  
  // 设备信息
  static const String platformAndroid = 'android';
  static const String platformIOS = 'ios';
  static const String platformWeb = 'web';
  static const String platformWindows = 'windows';
  static const String platformMacOS = 'macos';
  static const String platformLinux = 'linux';
  
  // 状态枚举
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';
  static const String statusPending = 'pending';
  static const String statusDeleted = 'deleted';
  static const String statusDraft = 'draft';
  static const String statusPublished = 'published';
  
  // 排序方式
  static const String sortOrderAsc = 'asc';
  static const String sortOrderDesc = 'desc';
  
  // 排序字段
  static const String sortByCreatedAt = 'created_at';
  static const String sortByUpdatedAt = 'updated_at';
  static const String sortByName = 'name';
  static const String sortByPrice = 'price';
  static const String sortByRating = 'rating';
  
  // HTTP 状态码
  static const int httpOk = 200;
  static const int httpCreated = 201;
  static const int httpBadRequest = 400;
  static const int httpUnauthorized = 401;
  static const int httpForbidden = 403;
  static const int httpNotFound = 404;
  static const int httpUnprocessableEntity = 422;
  static const int httpInternalServerError = 500;
  
  // 正则表达式
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^1[3-9]\d{9}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$';
  
  // 错误消息
  static const String errorNetwork = '网络连接失败，请检查网络设置';
  static const String errorTimeout = '请求超时，请稍后重试';
  static const String errorUnknown = '发生未知错误，请重试';
  static const String errorUnauthorized = '认证失败，请重新登录';
  static const String errorForbidden = '权限不足，无法访问该资源';
  static const String errorNotFound = '请求的资源不存在';
  static const String errorValidation = '输入数据验证失败';
  static const String errorServer = '服务器内部错误';
  static const String errorFileTooLarge = '文件大小超出限制';
  static const String errorFileType = '不支持的文件类型';
  static const String errorStorageFull = '存储空间不足';
  
  // 成功消息
  static const String successLogin = '登录成功';
  static const String successLogout = '登出成功';
  static const String successRegister = '注册成功';
  static const String successSave = '保存成功';
  static const String successDelete = '删除成功';
  static const String successUpdate = '更新成功';
  static const String successUpload = '上传成功';
  static const String successDownload = '下载成功';
  static const String successSend = '发送成功';
  static const String successRefresh = '刷新成功';
  static const String successSync = '同步成功';
  static const String successBackup = '备份成功';
  static const String successRestore = '恢复成功';
}