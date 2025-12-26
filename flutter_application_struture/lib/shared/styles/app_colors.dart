import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  
  // 主色调
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);
  
  // 辅助色调
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color secondaryLight = Color(0xFF4DB6AC);
  
  // 中性色调
  static const Color surface = Color(0xFFFAFAFA);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // 文字颜色
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textHint = Color(0xFF9E9E9E);
  
  // 状态颜色
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // 边框和分割线
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);
  
  // 透明色
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // 阴影
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  
  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );
}

class AppSpacing {
  AppSpacing._();
  
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  // 内边距
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  
  // 外边距
  static const EdgeInsets marginXS = EdgeInsets.all(xs);
  static const EdgeInsets marginSM = EdgeInsets.all(sm);
  static const EdgeInsets marginMD = EdgeInsets.all(md);
  static const EdgeInsets marginLG = EdgeInsets.all(lg);
  static const EdgeInsets marginXL = EdgeInsets.all(xl);
  
  // 水平/垂直边距
  static const EdgeInsets horizontalPaddingSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalPaddingMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalPaddingLG = EdgeInsets.symmetric(horizontal: lg);
  
  static const EdgeInsets verticalPaddingSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalPaddingMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalPaddingLG = EdgeInsets.symmetric(vertical: lg);
}

class AppTextStyles {
  AppTextStyles._();
  
  // 标题
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );
  
  // 正文
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.textSecondary,
  );
  
  // 按钮
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
  );
  
  // 输入框
  static const TextStyle input = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.textHint,
  );
}

class AppBorderRadius {
  AppBorderRadius._();
  
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double round = 999.0;
  
  // 圆角对象
  static BorderRadius radiusXS = BorderRadius.circular(xs);
  static BorderRadius radiusSM = BorderRadius.circular(sm);
  static BorderRadius radiusMD = BorderRadius.circular(md);
  static BorderRadius radiusLG = BorderRadius.circular(lg);
  static BorderRadius radiusXL = BorderRadius.circular(xl);
  static BorderRadius radiusXXL = BorderRadius.circular(xxl);
  static BorderRadius radiusRound = BorderRadius.circular(round);
}

class AppShadows {
  AppShadows._();
  
  // 阴影样式
  static const BoxShadow none = BoxShadow(
    color: AppColors.transparent,
    blurRadius: 0,
    offset: Offset.zero,
  );
  
  static const BoxShadow light = BoxShadow(
    color: AppColors.shadowLight,
    blurRadius: 2,
    offset: Offset(0, 1),
  );
  
  static const BoxShadow medium = BoxShadow(
    color: AppColors.shadow,
    blurRadius: 4,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow heavy = BoxShadow(
    color: AppColors.shadow,
    blurRadius: 8,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow card = BoxShadow(
    color: AppColors.shadowLight,
    blurRadius: 6,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow elevated = BoxShadow(
    color: AppColors.shadow,
    blurRadius: 12,
    offset: Offset(0, 6),
  );
}