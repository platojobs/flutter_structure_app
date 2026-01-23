import 'package:dio/dio.dart';
import '../../../core/exceptions/app_exceptions.dart' show ServerException, NetworkException, ValidationException, AuthException;
import '../../../core/utils/logger.dart';

abstract class RemoteDataSource {
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? queryParameters});
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> patch(String endpoint, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, dynamic>? data});
  Future<void> download(String url, String savePath, {Map<String, dynamic>? queryParameters});
  void setAuthToken(String token);
  void removeAuthToken();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio _dio;
  static const int _connectTimeout = 30000;
  static const int _receiveTimeout = 30000;
  static const int _sendTimeout = 30000;

  // 模拟用户数据
  static final Map<String, dynamic> _mockUsers = {
    'user1@example.com': {
      'id': 'user_001',
      'email': 'user1@example.com',
      'fullName': '张三',
      'phone': '13800138001',
      'avatar': 'https://via.placeholder.com/100',
      'status': 'active',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'metadata': {},
    },
    'user2@example.com': {
      'id': 'user_002',
      'email': 'user2@example.com',
      'fullName': '李四',
      'phone': '13800138002',
      'avatar': 'https://via.placeholder.com/100',
      'status': 'active',
      'createdAt': DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'metadata': {},
    },
  };

  // 模拟登录历史数据
  static final List<Map<String, dynamic>> _mockLoginHistory = [
    {
      'id': 'history_001',
      'ip': '127.0.0.1',
      'device': 'iPhone 14',
      'browser': 'Safari',
      'os': 'iOS 16',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'location': '中国北京',
      'isSuccessful': true,
    },
    {
      'id': 'history_002',
      'ip': '192.168.1.1',
      'device': 'MacBook Pro',
      'browser': 'Chrome',
      'os': 'macOS Ventura',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'location': '中国上海',
      'isSuccessful': true,
    },
  ];

  // 模拟用户权限和角色
  static final Map<String, dynamic> _mockAuthData = {
    'permissions': [
      {'id': 'view_products', 'name': '查看产品', 'description': '可以查看产品列表'},
      {'id': 'add_to_cart', 'name': '添加到购物车', 'description': '可以将产品添加到购物车'},
      {'id': 'manage_order', 'name': '管理订单', 'description': '可以查看和管理订单'},
    ],
    'roles': [
      {'id': 'user', 'name': '普通用户', 'description': '普通用户角色'},
    ],
  };

  // 模拟产品数据
  static final List<Map<String, dynamic>> _mockProducts = [
    {
      'id': 'product_001',
      'name': 'Apple iPhone 14 Pro',
      'description': '最新款iPhone，搭载A16芯片，支持灵动岛功能',
      'price': 7999.00,
      'originalPrice': 8999.00,
      'imageUrl': 'https://via.placeholder.com/300x300?text=iPhone+14+Pro',
      'imageUrls': [
        'https://via.placeholder.com/300x300?text=iPhone+14+Pro+1',
        'https://via.placeholder.com/300x300?text=iPhone+14+Pro+2',
        'https://via.placeholder.com/300x300?text=iPhone+14+Pro+3',
      ],
      'category': 'electronics',
      'status': 'active',
      'stockQuantity': 100,
      'rating': 4.8,
      'reviewCount': 2356,
      'specifications': {
        '屏幕尺寸': '6.1英寸',
        '存储容量': '128GB',
        '颜色': '深空黑色',
        '电池容量': '3200mAh',
      },
      'tags': ['手机', 'Apple', '新品', '5G'],
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'updatedAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'isFavorite': false,
      'discount': 1000.00,
    },
    {
      'id': 'product_002',
      'name': 'Sony WH-1000XM5',
      'description': '业界领先的降噪耳机，提供出色的音质和舒适的佩戴体验',
      'price': 2499.00,
      'originalPrice': 2999.00,
      'imageUrl': 'https://via.placeholder.com/300x300?text=Sony+WH-1000XM5',
      'imageUrls': [
        'https://via.placeholder.com/300x300?text=Sony+WH-1000XM5+1',
        'https://via.placeholder.com/300x300?text=Sony+WH-1000XM5+2',
      ],
      'category': 'electronics',
      'status': 'active',
      'stockQuantity': 50,
      'rating': 4.9,
      'reviewCount': 1892,
      'specifications': {
        '类型': '头戴式',
        '连接方式': '蓝牙5.2',
        '电池续航': '30小时',
        '重量': '250g',
      },
      'tags': ['耳机', '降噪', '无线', 'Sony'],
      'createdAt': DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
      'updatedAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
      'isFavorite': true,
      'discount': 500.00,
    },
    {
      'id': 'product_003',
      'name': 'Nike Air Max 270',
      'description': '经典气垫鞋，提供极佳的缓震效果和时尚外观',
      'price': 999.00,
      'originalPrice': 1299.00,
      'imageUrl': 'https://via.placeholder.com/300x300?text=Nike+Air+Max+270',
      'imageUrls': [
        'https://via.placeholder.com/300x300?text=Nike+Air+Max+270+1',
        'https://via.placeholder.com/300x300?text=Nike+Air+Max+270+2',
        'https://via.placeholder.com/300x300?text=Nike+Air+Max+270+3',
      ],
      'category': 'sports',
      'status': 'active',
      'stockQuantity': 200,
      'rating': 4.5,
      'reviewCount': 3421,
      'specifications': {
        '类型': '跑步鞋',
        '颜色': '白色/黑色',
        '尺码': '40-45',
        '材质': '织物',
      },
      'tags': ['运动鞋', 'Nike', '跑步', '气垫'],
      'createdAt': DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
      'updatedAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      'isFavorite': false,
      'discount': 300.00,
    },
    {
      'id': 'product_004',
      'name': 'Kindle Paperwhite 5',
      'description': '全新Kindle Paperwhite，支持防水和无线充电',
      'price': 1299.00,
      'originalPrice': 1499.00,
      'imageUrl': 'https://via.placeholder.com/300x300?text=Kindle+Paperwhite+5',
      'imageUrls': [
        'https://via.placeholder.com/300x300?text=Kindle+Paperwhite+5+1',
        'https://via.placeholder.com/300x300?text=Kindle+Paperwhite+5+2',
      ],
      'category': 'electronics',
      'status': 'active',
      'stockQuantity': 80,
      'rating': 4.7,
      'reviewCount': 1567,
      'specifications': {
        '屏幕尺寸': '6.8英寸',
        '存储容量': '8GB',
        '防水等级': 'IPX8',
        '电池续航': '10周',
      },
      'tags': ['电子书', 'Kindle', '防水', '阅读'],
      'createdAt': DateTime.now().subtract(const Duration(days: 120)).toIso8601String(),
      'updatedAt': DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
      'isFavorite': true,
      'discount': 200.00,
    },
    {
      'id': 'product_005',
      'name': 'Levi\'s 501 Original Jeans',
      'description': '经典Levi\'s牛仔裤，永恒的时尚选择',
      'price': 799.00,
      'originalPrice': 999.00,
      'imageUrl': 'https://via.placeholder.com/300x300?text=Levi\'s+501',
      'imageUrls': [
        'https://via.placeholder.com/300x300?text=Levi\'s+501+1',
        'https://via.placeholder.com/300x300?text=Levi\'s+501+2',
      ],
      'category': 'clothing',
      'status': 'active',
      'stockQuantity': 150,
      'rating': 4.6,
      'reviewCount': 2987,
      'specifications': {
        '类型': '直筒牛仔裤',
        '颜色': '深蓝色',
        '尺码': '28-38',
        '材质': '棉98%，弹性纤维2%',
      },
      'tags': ['牛仔裤', 'Levi\'s', '经典', '时尚'],
      'createdAt': DateTime.now().subtract(const Duration(days: 180)).toIso8601String(),
      'updatedAt': DateTime.now().subtract(const Duration(days: 25)).toIso8601String(),
      'isFavorite': false,
      'discount': 200.00,
    },
  ];

  // 模拟产品评价数据
  static final Map<String, List<Map<String, dynamic>>> _mockProductReviews = {
    'product_001': [
      {
        'id': 'review_001',
        'productId': 'product_001',
        'userId': 'user_001',
        'userName': '张三',
        'userAvatar': 'https://via.placeholder.com/50',
        'rating': 5,
        'comment': '非常好用的手机，性能强劲，拍照效果出色！',
        'images': null,
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'updatedAt': null,
        'helpfulCount': 12,
        'isVerifiedPurchase': true,
      },
      {
        'id': 'review_002',
        'productId': 'product_001',
        'userId': 'user_002',
        'userName': '李四',
        'userAvatar': 'https://via.placeholder.com/50',
        'rating': 4,
        'comment': '手机不错，就是价格有点贵',
        'images': null,
        'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'updatedAt': null,
        'helpfulCount': 5,
        'isVerifiedPurchase': true,
      },
    ],
  };

  // 模拟用户收藏产品
  static final Map<String, List<String>> _mockFavoriteProducts = {
    'user_001': ['product_002', 'product_004'],
    'user_002': [],
  };

  // 模拟最近查看产品
  static final Map<String, List<String>> _mockRecentlyViewed = {
    'user_001': ['product_001', 'product_003', 'product_005'],
    'user_002': ['product_002', 'product_004'],
  };

  RemoteDataSourceImpl({required String baseUrl}) : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(milliseconds: _connectTimeout),
    receiveTimeout: const Duration(milliseconds: _receiveTimeout),
    sendTimeout: const Duration(milliseconds: _sendTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // 请求拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        AppLogger.info('发送请求: ${options.method} ${options.uri}');
        AppLogger.debug('请求参数: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.info('请求成功: ${response.statusCode} ${response.requestOptions.uri}');
        AppLogger.debug('响应数据: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        AppLogger.error('请求失败: ${error.response?.statusCode} ${error.requestOptions.uri}');
        AppLogger.debug('错误信息: ${error.message}');
        AppLogger.debug('响应数据: ${error.response?.data}');
        handler.next(error);
      },
    ));
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      // 模拟认证相关接口的响应
      if (endpoint.startsWith('/auth/')) {
        return _getMockAuthResponse(endpoint, queryParameters);
      }

      // 模拟产品相关接口的响应
      if (endpoint.startsWith('/products')) {
        return _getMockProductResponse(endpoint, queryParameters);
      }

      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      // 模拟认证相关接口的响应
      if (endpoint.startsWith('/auth/')) {
        return _postMockAuthResponse(endpoint, data);
      }

      // 模拟产品相关接口的响应
      if (endpoint.startsWith('/products')) {
        return _postMockProductResponse(endpoint, data);
      }

      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      // 模拟产品相关接口的响应
      if (endpoint.startsWith('/products')) {
        return _putMockProductResponse(endpoint, data);
      }

      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> patch(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      // 模拟认证相关接口的响应
      if (endpoint.startsWith('/auth/')) {
        return _patchMockAuthResponse(endpoint, data);
      }

      // 模拟产品相关接口的响应
      if (endpoint.startsWith('/products/')) {
        return _patchMockProductResponse(endpoint, data);
      }

      final response = await _dio.patch(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      // 模拟产品相关接口的响应
      if (endpoint.startsWith('/products/')) {
        return _deleteMockProductResponse(endpoint, data);
      }

      final response = await _dio.delete(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '未知错误: $e');
    }
  }

  @override
  Future<void> download(String url, String savePath, {Map<String, dynamic>? queryParameters}) async {
    try {
      await _dio.download(url, savePath, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: '下载失败: $e');
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    
    if (statusCode >= 200 && statusCode < 300) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      } else {
        return {'data': data};
      }
    } else {
      throw _createHttpException(statusCode, response.data);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: '网络连接超时');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        return _createHttpException(statusCode, error.response?.data);
      case DioExceptionType.cancel:
        return ServerException(message: '请求已取消');
      case DioExceptionType.connectionError:
        return NetworkException(message: '网络连接错误');
      case DioExceptionType.unknown:
      default:
        return ServerException(message: '未知网络错误');
    }
  }

  AppException _createHttpException(int statusCode, dynamic data) {
    String message = 'HTTP错误 $statusCode';
    
    if (data != null) {
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['error'] ?? message;
      } else if (data is String) {
        message = data;
      }
    }

    switch (statusCode) {
      case 400:
        return ValidationException(message: message, code: 'BAD_REQUEST');
      case 401:
        return AuthException(message: '认证失败', code: 'UNAUTHORIZED');
      case 403:
        return AuthException(message: '权限不足', code: 'FORBIDDEN');
      case 404:
        return ServerException(message: '资源未找到', code: 'RESOURCE_NOT_FOUND');
      case 422:
        return ValidationException(message: message, code: 'UNPROCESSABLE_ENTITY');
      case 500:
        return ServerException(message: '服务器错误', code: 'INTERNAL_SERVER_ERROR');
      case 502:
        return ServerException(message: '服务器错误', code: 'BAD_GATEWAY');
      case 503:
        return ServerException(message: '服务器错误', code: 'SERVICE_UNAVAILABLE');
      case 504:
        return ServerException(message: '服务器错误', code: 'GATEWAY_TIMEOUT');
      default:
        return ServerException(message: message, code: 'HTTP_ERROR_$statusCode');
    }
  }

  @override
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // 处理认证相关GET请求的模拟响应
  Map<String, dynamic> _getMockAuthResponse(String endpoint, Map<String, dynamic>? queryParameters) {
    if (endpoint == '/auth/me') {
      // 返回模拟用户信息
      return {'user': _mockUsers.values.first};
    } else if (endpoint == '/auth/login-history') {
      // 返回模拟登录历史
      return {'histories': _mockLoginHistory};
    } else if (endpoint == '/auth/permissions') {
      // 返回模拟用户权限
      return {'permissions': _mockAuthData['permissions']};
    } else if (endpoint == '/auth/roles') {
      // 返回模拟用户角色
      return {'roles': _mockAuthData['roles']};
    }
    throw ServerException(message: '未找到模拟数据的端点: $endpoint');
  }

  // 处理认证相关POST请求的模拟响应
  Map<String, dynamic> _postMockAuthResponse(String endpoint, Map<String, dynamic>? data) {
    if (endpoint == '/auth/login') {
      // 模拟登录
      final email = data?['email'] as String?;
      final password = data?['password'] as String?;

      if (email != null && password != null && _mockUsers.containsKey(email)) {
        // 登录成功
        return {
          'user': _mockUsers[email],
          'accessToken': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
          'refreshToken': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        };
      } else {
        // 登录失败
        throw AuthException(message: '邮箱或密码错误');
      }
    } else if (endpoint == '/auth/register') {
      // 模拟注册
      final email = data?['email'] as String?;
      final password = data?['password'] as String?;
      final fullName = data?['fullName'] as String?;
      final phone = data?['phone'] as String?;

      if (email != null && password != null && fullName != null && !_mockUsers.containsKey(email)) {
        // 注册成功，创建新用户
        final newUser = {
          'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
          'email': email,
          'fullName': fullName,
          'phone': phone,
          'avatar': 'https://via.placeholder.com/100',
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'metadata': {},
        };

        // 添加到模拟用户列表
        _mockUsers[email] = newUser;

        return {
          'user': newUser,
          'accessToken': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
          'refreshToken': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        };
      } else {
        // 注册失败
        throw ValidationException(message: '邮箱已存在或参数不完整');
      }
    } else if (endpoint == '/auth/logout') {
      // 模拟登出
      return {'success': true, 'message': '登出成功'};
    } else if (endpoint == '/auth/refresh') {
      // 模拟刷新令牌
      return {
        'accessToken': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        'refreshToken': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        'expiresAt': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      };
    } else if (endpoint == '/auth/check-email') {
      // 模拟检查邮箱是否存在
      final email = data?['email'] as String?;
      return {'exists': _mockUsers.containsKey(email)};
    } else if (endpoint == '/auth/check-phone') {
      // 模拟检查手机号是否存在
      final phone = data?['phone'] as String?;
      final exists = _mockUsers.values.any((user) => user['phone'] == phone);
      return {'exists': exists};
    } else if (endpoint == '/auth/reset-password') {
      // 模拟发送密码重置邮件
      final email = data?['email'] as String?;
      if (email != null && _mockUsers.containsKey(email)) {
        return {'success': true, 'message': '密码重置邮件已发送'};
      } else {
        throw ValidationException(message: '邮箱不存在');
      }
    } else if (endpoint == '/auth/enable-2fa') {
      // 模拟启用双因子认证
      return {
        'secret': 'JBSWY3DPEHPK3PXP',
        'qrCode': 'https://via.placeholder.com/200',
        'message': '双因子认证已启用',
      };
    } else if (endpoint == '/auth/verify-2fa') {
      // 模拟验证双因子认证
      final code = data?['code'] as String?;
      if (code != null && code.length == 6) {
        return {'success': true, 'message': '双因子认证验证成功'};
      } else {
        throw ValidationException(message: '验证码无效');
      }
    }
    throw ServerException(message: '未找到模拟数据的端点: $endpoint');
  }

  // 处理认证相关PATCH请求的模拟响应
  Map<String, dynamic> _patchMockAuthResponse(String endpoint, Map<String, dynamic>? data) {
    if (endpoint == '/auth/profile') {
      // 模拟更新用户资料
      final currentUser = _mockUsers.values.first;
      final updatedUser = Map<String, dynamic>.from(currentUser);

      if (data != null) {
        updatedUser['fullName'] = data['fullName'] ?? updatedUser['fullName'];
        updatedUser['phone'] = data['phone'] ?? updatedUser['phone'];
        updatedUser['avatar'] = data['avatar'] ?? updatedUser['avatar'];
        updatedUser['updatedAt'] = DateTime.now().toIso8601String();
      }

      // 更新模拟用户数据
      _mockUsers[updatedUser['email'] as String] = updatedUser;

      return {'user': updatedUser};
    } else if (endpoint == '/auth/change-password') {
      // 模拟修改密码
      final oldPassword = data?['oldPassword'] as String?;
      final newPassword = data?['newPassword'] as String?;

      if (oldPassword != null && newPassword != null && oldPassword.length >= 6 && newPassword.length >= 6) {
        return {'success': true, 'message': '密码修改成功'};
      } else {
        throw ValidationException(message: '密码长度至少为6位');
      }
    }
    throw ServerException(message: '未找到模拟数据的端点: $endpoint');
  }

  // 辅助方法：获取当前登录用户ID
  String _getCurrentUserId() {
    return _mockUsers.values.first['id'] as String;
  }

  // 辅助方法：分页处理
  List<Map<String, dynamic>> _paginate(List<Map<String, dynamic>> items, int page, int limit) {
    final total = items.length;
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    return startIndex < total 
      ? items.sublist(startIndex, endIndex > total ? total : endIndex)
      : [];
  }

  // 辅助方法：生成分页响应
  Map<String, dynamic> _generatePaginationResponse(List<Map<String, dynamic>> items, int page, int limit) {
    final total = items.length;
    final paginatedItems = _paginate(items, page, limit);
    return {
      'products': paginatedItems,
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': (total / limit).ceil(),
    };
  }

  // 辅助方法：过滤产品
  List<Map<String, dynamic>> _filterProducts({String? category, String? searchQuery, bool includeTags = false, num? priceMin, num? priceMax}) {
    var filteredProducts = List<Map<String, dynamic>>.from(_mockProducts);
    
    if (category != null) {
      filteredProducts = filteredProducts.where((p) => p['category'] == category).toList();
    }
    
    if (searchQuery != null) {
      final query = searchQuery.toLowerCase();
      filteredProducts = filteredProducts.where((p) => 
        p['name'].toLowerCase().contains(query) || 
        p['description'].toLowerCase().contains(query) ||
        (includeTags && (p['tags'] as List<String>).any((tag) => tag.toLowerCase().contains(query)))
      ).toList();
    }
    
    // 价格范围过滤
    if (priceMin != null) {
      filteredProducts = filteredProducts.where((p) => (p['price'] as num) >= priceMin).toList();
    }
    
    if (priceMax != null) {
      filteredProducts = filteredProducts.where((p) => (p['price'] as num) <= priceMax).toList();
    }
    
    return filteredProducts;
  }

  // 处理产品相关GET请求的模拟响应
  Map<String, dynamic> _getMockProductResponse(String endpoint, Map<String, dynamic>? queryParameters) {
    // 获取当前登录用户ID（默认使用第一个用户）
    final userId = _getCurrentUserId();
    
    // 处理产品列表请求
    if (endpoint == '/products') {
      final page = (queryParameters?['page'] as int?) ?? 1;
      final limit = (queryParameters?['limit'] as int?) ?? 20;
      final category = queryParameters?['category'] as String?;
      final searchQuery = queryParameters?['search'] as String?;
      final priceMin = queryParameters?['priceMin'] as num?;
      final priceMax = queryParameters?['priceMax'] as num?;
      
      // 参数验证
      if (page < 1) {
        throw ValidationException(message: '页码必须大于等于1', code: 'PAGE_INVALID');
      }
      if (limit < 1 || limit > 100) {
        throw ValidationException(message: '每页数量必须在1-100之间', code: 'LIMIT_INVALID');
      }
      
      // 过滤产品
      final filteredProducts = _filterProducts(
        category: category, 
        searchQuery: searchQuery, 
        priceMin: priceMin, 
        priceMax: priceMax
      );
      
      // 分页
      return _generatePaginationResponse(filteredProducts, page, limit);
    }
    
    // 处理单个产品详情请求
    else if (endpoint.startsWith('/products/')) {
      final productId = endpoint.split('/').last;
      
      // 参数验证
      _validateProductId(productId);
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      // 检查是否是产品评价请求
      if (endpoint.endsWith('/reviews')) {
        final parts = endpoint.split('/');
        if (parts.length < 3) {
          throw ValidationException(message: '无效的产品评价请求路径', code: 'PRODUCT_REVIEW_PATH_INVALID');
        }
        final productReviewId = parts[2];
        
        // 验证产品是否存在
        final productExists = _mockProducts.any((p) => p['id'] == productReviewId);
        if (!productExists) {
          throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
        }
        
        final reviews = _mockProductReviews[productReviewId] ?? [];
        
        // 计算平均评分，确保只有有效的评分被计算
        final validReviews = reviews.where((r) => r['rating'] != null).toList();
        final averageRating = validReviews.isNotEmpty 
            ? validReviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) / validReviews.length
            : 0.0;
            
        return {
          'reviews': reviews,
          'averageRating': averageRating,
          'ratingDistribution': {
            5: validReviews.where((r) => r['rating'] == 5).length,
            4: validReviews.where((r) => r['rating'] == 4).length,
            3: validReviews.where((r) => r['rating'] == 3).length,
            2: validReviews.where((r) => r['rating'] == 2).length,
            1: validReviews.where((r) => r['rating'] == 1).length,
          },
          'total': validReviews.length,
          'page': 1,
          'limit': 10,
        };
      }
      
      // 产品详情请求
      final product = _mockProducts.firstWhere(
        (p) => p['id'] == productId,
        orElse: () => throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND'),
      );
      
      // 更新最近查看
      _updateRecentlyViewed(userId, productId);
      
      return {'product': product};
    }
    
    // 处理推荐产品请求
    else if (endpoint == '/products/recommended') {
      final limit = (queryParameters?['limit'] as int?) ?? 10;
      
      // 参数验证
      if (limit < 1 || limit > 100) {
        throw ValidationException(message: '推荐数量必须在1-100之间', code: 'RECOMMENDATION_COUNT_INVALID');
      }
      
      // 简单返回前N个产品作为推荐
      return {'products': _mockProducts.take(limit).toList()};
    }
    
    // 处理热门产品请求
    else if (endpoint == '/products/popular') {
      final limit = (queryParameters?['limit'] as int?) ?? 10;
      final category = queryParameters?['category'] as String?;
      
      // 参数验证
      if (limit < 1 || limit > 100) {
        throw ValidationException(message: '热门产品数量必须在1-100之间', code: 'HOT_PRODUCTS_COUNT_INVALID');
      }
      // 验证分类参数（如果提供）
      if (category != null) {
        _validateProductCategory(category);
      }
      
      // 使用统一的过滤方法
      var filteredProducts = _filterProducts(category: category);
      
      // 按评价数量排序
      filteredProducts.sort((a, b) => (b['reviewCount'] as int).compareTo(a['reviewCount'] as int));
      
      return {'products': filteredProducts.take(limit).toList()};
    }
    
    // 处理新品请求
    else if (endpoint == '/products/new') {
      final limit = (queryParameters?['limit'] as int?) ?? 10;
      final category = queryParameters?['category'] as String?;
      
      // 参数验证
      if (limit < 1 || limit > 100) {
        throw ValidationException(message: '新品数量必须在1-100之间', code: 'NEW_PRODUCTS_COUNT_INVALID');
      }
      // 验证分类参数（如果提供）
      if (category != null) {
        _validateProductCategory(category);
      }
      
      // 使用统一的过滤方法
      var filteredProducts = _filterProducts(category: category);
      
      // 按创建时间排序
      filteredProducts.sort((a, b) => DateTime.parse(b['createdAt'] as String)
          .compareTo(DateTime.parse(a['createdAt'] as String)));
      
      return {'products': filteredProducts.take(limit).toList()};
    }
    
    // 处理促销产品请求
    else if (endpoint == '/products/on-sale') {
      final limit = (queryParameters?['limit'] as int?) ?? 10;
      
      // 参数验证
      if (limit < 1 || limit > 100) {
        throw ValidationException(message: '促销产品数量必须在1-100之间', code: 'ON_SALE_PRODUCTS_COUNT_INVALID');
      }
      
      // 过滤出有折扣的产品
      final onSaleProducts = _getOnSaleProducts();
      
      return {'products': onSaleProducts.take(limit).toList()};
    }
    
    // 处理分类产品请求
    else if (endpoint.startsWith('/products/category/')) {
      final category = endpoint.split('/').last;
      final page = (queryParameters?['page'] as int?) ?? 1;
      final limit = (queryParameters?['limit'] as int?) ?? 20;
      
      // 参数验证
      _validateProductCategory(category);
      if (page < 1) {
        throw ValidationException(message: '页码必须大于等于1', code: 'PAGE_INVALID');
      }
      if (limit < 1 || limit > 100) {
        throw ValidationException(message: '每页数量必须在1-100之间', code: 'LIMIT_INVALID');
      }
      
      // 使用统一的过滤方法
      final categoryProducts = _filterProducts(category: category);
      
      // 分页
      return _generatePaginationResponse(categoryProducts, page, limit);
    }
    
    // 处理搜索产品请求
    else if (endpoint == '/products/search') {
      final query = queryParameters?['query'] as String?;
      final page = (queryParameters?['page'] as int?) ?? 1;
      final limit = (queryParameters?['limit'] as int?) ?? 20;
      
      // 参数验证
      if (query == null || query.isEmpty) {
        throw ValidationException(message: '搜索关键词不能为空', code: 'SEARCH_QUERY_EMPTY');
      }
      if (query.length < 2) {
        throw ValidationException(message: '搜索关键词长度不能少于2个字符', code: 'SEARCH_QUERY_TOO_SHORT');
      }
      if (page < 1) {
        throw ValidationException(message: '页码必须大于等于1', code: 'PAGE_INVALID');
      }
      if (limit < 1 || limit > 100) {
        throw ValidationException(message: '每页数量必须在1-100之间', code: 'LIMIT_INVALID');
      }
      
      // 使用改进的过滤方法，包含标签搜索
      final searchResults = _filterProducts(searchQuery: query, includeTags: true);
      
      // 分页
      return _generatePaginationResponse(searchResults, page, limit);
    }
    
    // 处理收藏产品请求
    else if (endpoint == '/products/favorites') {
      final page = (queryParameters?['page'] as int?) ?? 1;
      final limit = (queryParameters?['limit'] as int?) ?? 20;
      
      // 参数验证
      if (page < 1) {
        throw ValidationException(message: '页码必须大于等于1', code: 'PAGE_INVALID');
      }
      if (limit < 1 || limit > 100) {
        throw ValidationException(message: '每页数量必须在1-100之间', code: 'LIMIT_INVALID');
      }
      
      final favoriteIds = _mockFavoriteProducts[userId] ?? [];
      final favoriteProducts = _mockProducts.where((p) => favoriteIds.contains(p['id'])).toList();
      
      // 分页
      return _generatePaginationResponse(favoriteProducts, page, limit);
    }
    
    // 处理最近查看产品请求
    else if (endpoint == '/products/recently-viewed') {
      final limit = (queryParameters?['limit'] as int?) ?? 10;
      
      // 参数验证
      if (limit < 1 || limit > 50) {
        throw ValidationException(message: '最近查看产品数量必须在1-50之间', code: 'RECENTLY_VIEWED_LIMIT_INVALID');
      }
      
      final recentlyViewedIds = _mockRecentlyViewed[userId] ?? [];
      // 保持顺序并去重
      final uniqueIds = recentlyViewedIds.toSet().toList();
      // 按最近查看顺序排序
      final recentlyViewedProducts = uniqueIds.map((id) => 
        _mockProducts.firstWhere((p) => p['id'] == id)
      ).take(limit).toList();
      
      return {'products': recentlyViewedProducts};
    }
    
    // 处理产品标签请求
    else if (endpoint == '/products/tags') {
      final category = queryParameters?['category'] as String?;
      
      var filteredProducts = List<Map<String, dynamic>>.from(_mockProducts);
      if (category != null) {
        filteredProducts = filteredProducts.where((p) => p['category'] == category).toList();
      }
      
      // 提取所有标签并去重
      final allTags = <String>{};
      for (final product in filteredProducts) {
        allTags.addAll(product['tags'] as List<String>);
      }
      
      return {'tags': allTags.toList()};
    }
    
    // 处理产品属性请求
    else if (endpoint == '/products/attributes') {
      return {
        'attributes': [
          {
            'id': 'attribute_001',
            'name': '颜色',
            'values': ['红色', '蓝色', '黑色', '白色'],
            'isRequired': false,
            'isFilterable': true,
          },
          {
            'id': 'attribute_002',
            'name': '尺寸',
            'values': ['S', 'M', 'L', 'XL', 'XXL'],
            'isRequired': false,
            'isFilterable': true,
          },
          {
            'id': 'attribute_003',
            'name': '品牌',
            'values': ['Apple', 'Sony', 'Nike', 'Kindle', 'Levi\'s'],
            'isRequired': false,
            'isFilterable': true,
          },
        ],
      };
    }
    
    // 处理产品变体请求
    else if (endpoint.endsWith('/variants')) {
      final productId = endpoint.split('/')[2];
      
      return {
        'variants': [
          {
            'id': 'variant_001',
            'name': '颜色',
            'value': '红色',
            'price': null,
            'stockQuantity': 50,
            'imageUrl': 'https://via.placeholder.com/100x100?text=Red',
          },
          {
            'id': 'variant_002',
            'name': '颜色',
            'value': '蓝色',
            'price': null,
            'stockQuantity': 30,
            'imageUrl': 'https://via.placeholder.com/100x100?text=Blue',
          },
          {
            'id': 'variant_003',
            'name': '尺寸',
            'value': 'S',
            'price': null,
            'stockQuantity': 20,
            'imageUrl': null,
          },
          {
            'id': 'variant_004',
            'name': '尺寸',
            'value': 'M',
            'price': null,
            'stockQuantity': 40,
            'imageUrl': null,
          },
        ],
      };
    }
    
    // 处理产品库存请求
    else if (endpoint.endsWith('/stock')) {
      final productId = endpoint.split('/')[2];
      final product = _mockProducts.firstWhere(
        (p) => p['id'] == productId,
        orElse: () => throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND'),
      );
      return {'stock': product['stockQuantity']};
    }
    
    // 处理产品可用性请求
    else if (endpoint.endsWith('/availability')) {
      final productId = endpoint.split('/')[2];
      final product = _mockProducts.firstWhere(
        (p) => p['id'] == productId,
        orElse: () => throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND'),
      );
      return {'available': product['stockQuantity'] > 0 && product['status'] == 'active'};
    }
    
    // 处理相关产品请求
    else if (endpoint.endsWith('/related')) {
      final productId = endpoint.split('/')[2];
      final limit = (queryParameters?['limit'] as int?) ?? 6;
      
      // 参数验证
      if (productId == null || productId.isEmpty) {
        throw ValidationException(message: '产品ID不能为空', code: 'PRODUCT_ID_EMPTY');
      }
      if (limit < 1 || limit > 20) {
        throw ValidationException(message: '相关产品数量必须在1-20之间', code: 'RELATED_PRODUCTS_LIMIT_INVALID');
      }
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      // 返回除了当前产品之外的前N个产品作为相关产品
      final relatedProducts = _mockProducts.where((p) => p['id'] != productId).take(limit).toList();
      return {'products': relatedProducts};
    }
    
    // 处理产品价格历史请求
    else if (endpoint.endsWith('/price-history')) {
      final productId = endpoint.split('/')[2];
      
      return {
        'history': [
          {
            'id': 'history_001',
            'productId': productId,
            'price': 8999.00,
            'effectiveDate': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
            'source': '系统',
          },
          {
            'id': 'history_002',
            'productId': productId,
            'price': 7999.00,
            'effectiveDate': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
            'source': '系统',
          },
        ],
      };
    }
    
    // 处理收藏检查请求
    else if (endpoint == '/products/favorites/check') {
      final productId = queryParameters?['productId'] as String?;
      if (productId == null || productId.isEmpty) {
        throw ValidationException(message: '产品ID不能为空', code: 'PRODUCT_ID_EMPTY');
      }
      final favoriteIds = _mockFavoriteProducts[userId] ?? [];
      return {'isFavorite': favoriteIds.contains(productId)};
    }
    
    // 处理产品统计请求
    else if (endpoint == '/products/statistics') {
      return {
        'totalProducts': _mockProducts.length,
        'activeProducts': _mockProducts.where((p) => p['status'] == 'active').length,
        'inactiveProducts': _mockProducts.where((p) => p['status'] != 'active').length,
        'totalStock': _mockProducts.map((p) => p['stockQuantity'] as int).reduce((a, b) => a + b),
        'averagePrice': _mockProducts.isNotEmpty
            ? _mockProducts.map((p) => p['price'] as num).reduce((a, b) => a + b) / _mockProducts.length
            : 0.0,
        'categories': {
          'electronics': _mockProducts.where((p) => p['category'] == 'electronics').length,
          'sports': _mockProducts.where((p) => p['category'] == 'sports').length,
          'clothing': _mockProducts.where((p) => p['category'] == 'clothing').length,
        },
      };
    }
    
    throw ServerException(message: '未找到模拟数据的端点: $endpoint');
  }

  // 辅助方法：获取当前用户信息
  Map<String, dynamic> _getCurrentUser() {
    return _mockUsers.values.first;
  }

  // 辅助方法：验证产品ID
  void _validateProductId(String? productId) {
    if (productId == null || productId.isEmpty) {
      throw ValidationException(message: '产品ID不能为空', code: 'PRODUCT_ID_EMPTY');
    }
  }

  // 辅助方法：验证产品名称
  void _validateProductName(String? name) {
    if (name == null || name.isEmpty) {
      throw ValidationException(message: '产品名称不能为空', code: 'PRODUCT_NAME_EMPTY');
    }
    if (name.length > 100) {
      throw ValidationException(message: '产品名称长度不能超过100个字符', code: 'PRODUCT_NAME_TOO_LONG');
    }
  }

  // 辅助方法：验证产品价格
  void _validateProductPrice(num? price, num? originalPrice) {
    if (price == null || price <= 0) {
      throw ValidationException(message: '产品价格必须大于0', code: 'PRODUCT_PRICE_INVALID');
    }
    if (originalPrice != null && originalPrice < price) {
      throw ValidationException(message: '原始价格不能小于当前价格', code: 'ORIGINAL_PRICE_INVALID');
    }
  }

  // 辅助方法：验证产品原始价格
  void _validateOriginalPrice(num? originalPrice, num? currentPrice) {
    if (originalPrice != null && originalPrice < 0) {
      throw ValidationException(message: '原始价格不能为负数', code: 'ORIGINAL_PRICE_NEGATIVE');
    }
    if (currentPrice != null && originalPrice != null && originalPrice < currentPrice) {
      throw ValidationException(message: '原始价格不能小于当前价格', code: 'ORIGINAL_PRICE_INVALID');
    }
  }

  // 辅助方法：验证产品库存数量
  void _validateStockQuantity(int? stockQuantity) {
    if (stockQuantity != null && stockQuantity < 0) {
      throw ValidationException(message: '库存数量不能为负数', code: 'STOCK_QUANTITY_NEGATIVE');
    }
  }

  // 辅助方法：验证产品状态
  void _validateProductStatus(String? status) {
    if (status != null) {
      const validStatuses = ['active', 'inactive', 'draft', 'deleted'];
      if (!validStatuses.contains(status)) {
        throw ValidationException(message: '无效的状态值，有效值: ${validStatuses.join(', ')}', code: 'PRODUCT_STATUS_INVALID');
      }
    }
  }

  // 辅助方法：验证产品图片URLs
  void _validateProductImages(List<String>? imageUrls) {
    if (imageUrls != null && imageUrls.length > 10) {
      throw ValidationException(message: '产品图片数量不能超过10张', code: 'PRODUCT_IMAGES_TOO_MANY');
    }
  }

  // 辅助方法：验证产品标签
  void _validateProductTags(List<String>? tags) {
    if (tags != null && tags.length > 20) {
      throw ValidationException(message: '产品标签数量不能超过20个', code: 'PRODUCT_TAGS_TOO_MANY');
    }
  }

  // 辅助方法：验证产品主图URL
  void _validateMainImageUrl(String? imageUrl) {
    if (imageUrl != null && imageUrl.isEmpty) {
      throw ValidationException(message: '产品主图URL不能为空', code: 'PRODUCT_MAIN_IMAGE_EMPTY');
    }
  }

  // 辅助方法：验证产品分类
  void _validateProductCategory(String? category) {
    if (category == null || category.isEmpty) {
      throw ValidationException(message: '产品分类不能为空', code: 'PRODUCT_CATEGORY_EMPTY');
    }
  }

  // 辅助方法：验证产品评分
  void _validateProductRating(int? rating) {
    if (rating == null || rating < 1 || rating > 5) {
      throw ValidationException(message: '评分必须在1-5之间', code: 'PRODUCT_RATING_INVALID');
    }
  }

  // 辅助方法：更新产品评分和评价数量
  void _updateProductRatingAndCount(String productId) {
    final reviews = _mockProductReviews[productId] ?? [];
    // 确保产品存在
    final product = _mockProducts.firstWhere(
      (p) => p['id'] == productId,
      orElse: () => throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND')
    );
    
    if (reviews.isEmpty) {
      product['rating'] = 0.0;
      product['reviewCount'] = 0;
    } else {
      // 计算平均评分，确保每个评价都有有效的rating值
      final validReviews = reviews.where((r) => r['rating'] != null).toList();
      if (validReviews.isEmpty) {
        product['rating'] = 0.0;
        product['reviewCount'] = 0;
      } else {
        final totalRating = validReviews.map((r) => r['rating'] as int).reduce((a, b) => a + b);
        product['rating'] = totalRating / validReviews.length;
        product['reviewCount'] = validReviews.length;
      }
    }
  }

  // 辅助方法：更新产品信息
  Map<String, dynamic> _updateProductInfo(String productId, Map<String, dynamic>? data) {
    final productIndex = _mockProducts.indexWhere((p) => p['id'] == productId);
    if (productIndex == -1) {
      throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
    }
    
    final product = _mockProducts[productIndex];
    
    // 更新产品信息
    if (data?['name'] != null) product['name'] = data?['name'];
    if (data?['description'] != null) product['description'] = data?['description'];
    if (data?['price'] != null) {
      product['price'] = data?['price'];
      // 更新折扣 - 只有当originalPrice存在时才计算折扣，且确保折扣不为负
      if (product['originalPrice'] != null) {
        product['discount'] = ((product['originalPrice'] as num) - (data?['price'] as num)).clamp(0, double.infinity);
      } else {
        product['discount'] = 0.0;
      }
    }
    if (data?['originalPrice'] != null) {
      product['originalPrice'] = data?['originalPrice'];
      // 更新折扣 - 只有当price存在时才计算折扣，且确保折扣不为负
      if (product['price'] != null) {
        product['discount'] = ((data?['originalPrice'] as num) - (product['price'] as num)).clamp(0, double.infinity);
      } else {
        product['discount'] = 0.0;
      }
    }
    if (data?['imageUrl'] != null) product['imageUrl'] = data?['imageUrl'];
    if (data?['imageUrls'] != null) product['imageUrls'] = data?['imageUrls'];
    if (data?['category'] != null) product['category'] = data?['category'];
    if (data?['status'] != null) product['status'] = data?['status'];
    if (data?['stockQuantity'] != null) product['stockQuantity'] = data?['stockQuantity'];
    if (data?['specifications'] != null) product['specifications'] = data?['specifications'];
    if (data?['tags'] != null) product['tags'] = data?['tags'];
    
    // 更新时间
    product['updatedAt'] = DateTime.now().toIso8601String();
    
    _mockProducts[productIndex] = product;
    
    return product;
  }

  // 处理产品相关PUT请求的模拟响应
  Map<String, dynamic> _putMockProductResponse(String endpoint, Map<String, dynamic>? data) {
    // 处理更新产品请求
    if (endpoint.startsWith('/products/') && endpoint.split('/').length == 3) {
      final productId = endpoint.split('/')[2];
      
      // 参数验证
      if (data == null || data.isEmpty) {
        throw ValidationException(message: '更新数据不能为空', code: 'UPDATE_DATA_EMPTY');
      }
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      // 验证关键字段（如果提供）
      if (data.containsKey('name')) {
        _validateProductName(data['name'] as String?);
      }
      
      if (data.containsKey('price') || data.containsKey('originalPrice')) {
        final price = data.containsKey('price') ? data['price'] as num? : null;
        final originalPrice = data.containsKey('originalPrice') ? data['originalPrice'] as num? : null;
        
        if (price != null) {
          // 获取现有产品的原始价格（如果未提供）
          final existingOriginalPrice = originalPrice ?? _mockProducts.firstWhere((p) => p['id'] == productId)['originalPrice'] as num?;
          _validateProductPrice(price, existingOriginalPrice);
        } else if (originalPrice != null) {
          // 获取现有产品的当前价格
          final existingPrice = _mockProducts.firstWhere((p) => p['id'] == productId)['price'] as num;
          _validateOriginalPrice(originalPrice, existingPrice);
        }
      }
      
      if (data.containsKey('stockQuantity')) {
        _validateStockQuantity(data['stockQuantity'] as int?);
      }
      
      if (data.containsKey('status')) {
        _validateProductStatus(data['status'] as String?);
      }
      
      if (data.containsKey('imageUrls')) {
        _validateProductImages(data['imageUrls'] as List<String>?);
      }
      
      if (data.containsKey('tags')) {
        _validateProductTags(data['tags'] as List<String>?);
      }
      
      if (data.containsKey('imageUrl')) {
        _validateMainImageUrl(data['imageUrl'] as String?);
      }
      
      if (data.containsKey('category')) {
        _validateProductCategory(data['category'] as String?);
      }
      
      final updatedProduct = _updateProductInfo(productId, data);
      return {'product': updatedProduct, 'message': '产品更新成功'};
    }
    
    throw ServerException(message: '未找到模拟数据的端点: $endpoint');
  }

  // 更新最近查看的产品
    void _updateRecentlyViewed(String userId, String productId) {
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
    
    final recentlyViewed = _mockRecentlyViewed[userId] ?? [];
    
    // 移除已存在的相同产品ID（避免重复）
    recentlyViewed.remove(productId);
    
    // 添加到列表开头
    recentlyViewed.insert(0, productId);
    
    // 限制最多保存10个
    if (recentlyViewed.length > 10) {
      recentlyViewed.removeLast();
    }
    
    _mockRecentlyViewed[userId] = recentlyViewed;
  }

  // 处理产品相关PATCH请求的模拟响应
  Map<String, dynamic> _patchMockProductResponse(String endpoint, Map<String, dynamic>? data) {
    // 处理部分更新产品请求
    if (endpoint.startsWith('/products/') && endpoint.split('/').length == 3) {
      final productId = endpoint.split('/')[2];
      
      // 参数验证
      _validateProductId(productId);
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      // 如果有更新数据，验证关键字段
      if (data != null) {
        if (data.containsKey('name')) {
          _validateProductName(data['name'] as String?);
        }
        
        if (data.containsKey('price')) {
          // 获取现有产品的原始价格
          final existingProduct = _mockProducts.firstWhere((p) => p['id'] == productId);
          final existingOriginalPrice = existingProduct['originalPrice'] as num?;
          _validateProductPrice(data['price'] as num?, existingOriginalPrice);
        }
        
        if (data.containsKey('stockQuantity')) {
          _validateStockQuantity(data['stockQuantity'] as int?);
        }
        
        if (data.containsKey('status')) {
          _validateProductStatus(data['status'] as String?);
        }
        
        if (data.containsKey('imageUrls')) {
          _validateProductImages(data['imageUrls'] as List<String>?);
        }
        
        if (data.containsKey('tags')) {
          _validateProductTags(data['tags'] as List<String>?);
        }
        
        if (data.containsKey('imageUrl')) {
          _validateMainImageUrl(data['imageUrl'] as String?);
        }
      }
      
      final updatedProduct = _updateProductInfo(productId, data);
      return {'product': updatedProduct, 'message': '产品部分更新成功'};
    }
    
    // 处理更新产品库存请求
    else if (endpoint.endsWith('/stock')) {
      final productId = endpoint.split('/')[2];
      final stockQuantity = data?['stockQuantity'] as int?;
      
      // 参数验证
      _validateProductId(productId);
      _validateStockQuantity(stockQuantity);
      if (stockQuantity == null) {
        throw ValidationException(message: '库存数量不能为空', code: 'STOCK_QUANTITY_EMPTY');
      }
      
      // 验证产品是否存在
      final productIndex = _mockProducts.indexWhere((p) => p['id'] == productId);
      if (productIndex == -1) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      final product = _mockProducts[productIndex];
      product['stockQuantity'] = stockQuantity;
      product['updatedAt'] = DateTime.now().toIso8601String();
      
      _mockProducts[productIndex] = product;
      
      return {'product': product, 'message': '产品库存更新成功'};
    }
    
    // 处理批量更新产品状态请求
    else if (endpoint == '/products/status') {
      final productIds = data?['productIds'] as List<String>?;
      final status = data?['status'] as String?;
      
      // 参数验证
      if (productIds == null || productIds.isEmpty) {
        throw ValidationException(message: '产品ID列表不能为空', code: 'PRODUCT_IDS_EMPTY');
      }
      _validateProductStatus(status);
      
      // 验证产品ID是否重复
      final uniqueProductIds = productIds.toSet();
      if (uniqueProductIds.length != productIds.length) {
        throw ValidationException(message: '产品ID列表中存在重复项', code: 'PRODUCT_IDS_DUPLICATE');
      }
      
      int updatedCount = 0;
      for (final productId in uniqueProductIds) {
        final productIndex = _mockProducts.indexWhere((p) => p['id'] == productId);
        if (productIndex != -1) {
          final product = _mockProducts[productIndex];
          product['status'] = status;
          product['updatedAt'] = DateTime.now().toIso8601String();
          _mockProducts[productIndex] = product;
          updatedCount++;
        }
      }
      
      return {'success': true, 'message': '批量更新成功', 'updatedCount': updatedCount, 'totalCount': uniqueProductIds.length};
    }
    
    throw ServerException(message: '未找到模拟数据的端点: $endpoint');
  }

  // 辅助方法：清理与产品相关的数据
  void _cleanupRelatedProductData(String productId) {
    // 从所有用户的收藏中删除产品
    _mockFavoriteProducts.forEach((user, products) {
      products.remove(productId);
    });
    
    // 从所有用户的最近查看中删除产品
    _mockRecentlyViewed.forEach((user, products) {
      products.remove(productId);
    });
    
    // 删除产品的评价数据
    _mockProductReviews.remove(productId);
  }

  // 辅助方法：获取促销产品
  List<Map<String, dynamic>> _getOnSaleProducts() {
    return _mockProducts.where((p) => 
      p['originalPrice'] != null && 
      p['price'] != null && 
      (p['originalPrice'] as num) > (p['price'] as num)
    ).toList();
  }

  // 处理产品相关DELETE请求的模拟响应
  Map<String, dynamic> _deleteMockProductResponse(String endpoint, Map<String, dynamic>? data) {
    // 获取当前登录用户ID（默认使用第一个用户）
    final userId = _getCurrentUserId();
    
    // 处理删除产品请求
    if (endpoint.startsWith('/products/') && endpoint.split('/').length == 3) {
      final productId = endpoint.split('/')[2];
      
      // 参数验证
      if (productId.isEmpty) {
        throw ValidationException(message: '产品ID不能为空', code: 'PRODUCT_ID_EMPTY');
      }
      
      final productIndex = _mockProducts.indexWhere((p) => p['id'] == productId);
      if (productIndex == -1) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      // 删除产品
      _mockProducts.removeAt(productIndex);
      
      // 清理相关数据
      _cleanupRelatedProductData(productId);
      
      return {'success': true, 'message': '产品删除成功'};
    }
    
    // 处理移除收藏请求
    else if (endpoint.endsWith('/favorites')) {
      final productId = endpoint.split('/')[2];
      
      // 参数验证
      if (productId.isEmpty) {
        throw ValidationException(message: '产品ID不能为空', code: 'PRODUCT_ID_EMPTY');
      }
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      final favorites = _mockFavoriteProducts[userId] ?? [];
      if (favorites.contains(productId)) {
        favorites.remove(productId);
        _mockFavoriteProducts[userId] = favorites;
      }
      
      return {'success': true, 'message': '移除收藏成功'};
    }
    
    // 处理删除产品评价请求
    else if (endpoint.endsWith('/reviews/')) {
      final parts = endpoint.split('/');
      final productId = parts[2];
      final reviewId = parts[4];
      
      // 参数验证
      if (productId.isEmpty) {
        throw ValidationException(message: '产品ID不能为空', code: 'PRODUCT_ID_EMPTY');
      }
      
      if (reviewId.isEmpty) {
        throw ValidationException(message: '评价ID不能为空', code: 'REVIEW_ID_EMPTY');
      }
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      final reviews = _mockProductReviews[productId] ?? [];
      final reviewIndex = reviews.indexWhere((r) => r['id'] == reviewId);
      
      if (reviewIndex != -1) {
        reviews.removeAt(reviewIndex);
        _mockProductReviews[productId] = reviews;
        
        // 更新产品的评分和评价数量
        _updateProductRatingAndCount(productId);
        
        return {'success': true, 'message': '评价删除成功'};
      } else {
        throw ServerException(message: '评价不存在', code: 'REVIEW_NOT_FOUND');
      }
    }
    
    throw ServerException(message: '未找到模拟数据的端点: $endpoint');
  }

  // 处理产品相关POST请求的模拟响应
  Map<String, dynamic> _postMockProductResponse(String endpoint, Map<String, dynamic>? data) {
    // 获取当前登录用户ID（默认使用第一个用户）
    final userId = _getCurrentUserId();
    
    // 处理添加收藏请求
    if (endpoint == '/products/favorites') {
      final productId = data?['productId'] as String?;
      if (productId == null || productId.isEmpty) {
        throw ValidationException(message: '产品ID不能为空', code: 'PRODUCT_ID_EMPTY');
      }
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      final favorites = _mockFavoriteProducts[userId] ?? [];
      if (!favorites.contains(productId)) {
        favorites.add(productId);
        _mockFavoriteProducts[userId] = favorites;
      }
      
      return {'success': true, 'message': '添加收藏成功'};
    }
    
    // 处理添加产品评价请求
    else if (endpoint.endsWith('/reviews')) {
      final productId = endpoint.split('/')[2];
      final rating = data?['rating'] as int?;
      final comment = data?['comment'] as String?;
      
      // 参数验证
      _validateProductId(productId);
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      _validateProductRating(rating);
      
      if (comment != null && comment.length > 1000) {
        throw ValidationException(message: '评论内容长度不能超过1000个字符', code: 'PRODUCT_COMMENT_TOO_LONG');
      }
      
      final reviews = _mockProductReviews[productId] ?? [];
      final currentUser = _getCurrentUser();
      final newReview = {
        'id': 'review_${DateTime.now().millisecondsSinceEpoch}',
        'productId': productId,
        'userId': userId,
        'userName': currentUser['fullName'] as String,
        'userAvatar': currentUser['avatar'] as String,
        'rating': rating,
        'comment': comment ?? '',
        'images': data?['images'] ?? [],
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': null,
        'helpfulCount': 0,
        'isVerifiedPurchase': true,
      };
      
      reviews.add(newReview);
      _mockProductReviews[productId] = reviews;
      
      // 更新产品的评分和评价数量
      _updateProductRatingAndCount(productId);
      
      return {'review': newReview, 'message': '评价添加成功'};
    }
    
    // 处理记录产品浏览请求
    else if (endpoint.endsWith('/view')) {
      final productId = endpoint.split('/')[2];
      
      // 参数验证
      if (productId.isEmpty) {
        throw ValidationException(message: '产品ID不能为空', code: 'PRODUCT_ID_EMPTY');
      }
      
      // 验证产品是否存在
      final productExists = _mockProducts.any((p) => p['id'] == productId);
      if (!productExists) {
        throw ServerException(message: '产品不存在', code: 'PRODUCT_NOT_FOUND');
      }
      
      _updateRecentlyViewed(userId, productId);
      return {'success': true, 'message': '浏览记录更新成功'};
    }
    
    // 处理创建产品请求
    else if (endpoint == '/products') {
      final name = data?['name'] as String?;
      final price = data?['price'] as num?;
      final description = data?['description'] as String?;
      final category = data?['category'] as String?;
      final originalPrice = data?['originalPrice'] as num?;
      final imageUrls = data?['imageUrls'] as List<String>?;
      final tags = data?['tags'] as List<String>?;
      final status = data?['status'] as String?;
      
      // 参数验证
      _validateProductName(name);
      _validateProductPrice(price, originalPrice);
      
      // 验证产品分类
      _validateProductCategory(category);
      
      _validateProductImages(imageUrls);
      _validateMainImageUrl(data?['imageUrl'] as String?);
      _validateProductTags(tags);
      
      // 验证库存数量
      final stockQuantity = data?['stockQuantity'] as int?;
      _validateStockQuantity(stockQuantity);
      
      if (status != null) {
        _validateProductStatus(status);
      }
      
      final newProduct = {
        'id': 'product_${DateTime.now().millisecondsSinceEpoch}',
        'name': name,
        'description': description ?? '',
        'price': price,
        'originalPrice': data?['originalPrice'] ?? price,
        'imageUrl': data?['imageUrl'] ?? 'https://via.placeholder.com/300x300?text=New+Product',
        'imageUrls': data?['imageUrls'] ?? [],
        'category': category,
        'status': data?['status'] ?? 'active',
        'stockQuantity': stockQuantity ?? 0,
        'rating': 0.0,
        'reviewCount': 0,
        'specifications': data?['specifications'] ?? {},
        'tags': data?['tags'] ?? [],
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'isFavorite': false,
        'discount': data?['originalPrice'] != null ? (data?['originalPrice'] as num) - price : 0,
      };
      
      _mockProducts.add(newProduct);
      return {'product': newProduct, 'message': '产品创建成功'};
    }
    
    // 处理产品同步请求
    else if (endpoint == '/products/sync') {
      return {'success': true, 'message': '产品数据同步成功', 'syncedCount': _mockProducts.length};
    }
    
    throw ServerException(message: '未找到模拟数据的端点: $endpoint');
  }
}