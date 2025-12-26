import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class AppLoading extends StatelessWidget {
  final String? message;
  final double? size;
  final Color? color;
  final bool showBackground;

  const AppLoading({
    super.key,
    this.message,
    this.size = 24.0,
    this.color,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showBackground) {
      return Container(
        color: AppColors.background.withOpacity(0.8),
        child: Center(
          child: _buildLoadingContent(),
        ),
      );
    }

    return _buildLoadingContent();
  }

  Widget _buildLoadingContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.primary,
            ),
          ),
        ),
        if (message != null) ..[
          const SizedBox(height: AppSpacing.md),
          Text(
            message!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class AppLoadingButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const AppLoadingButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : child,
      ),
    );
  }
}

class AppProgressIndicator extends StatelessWidget {
  final double? value;
  final double height;
  final Color? backgroundColor;
  final Color? valueColor;
  final bool showLabel;

  const AppProgressIndicator({
    super.key,
    this.value,
    this.height = 4.0,
    this.backgroundColor,
    this.valueColor,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && value != null) ..[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '进度',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(value! * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        LinearProgressIndicator(
          value: value,
          backgroundColor: backgroundColor ?? AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? AppColors.primary,
          ),
          minHeight: height,
        ),
      ],
    );
  }
}

class AppSkeletalLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const AppSkeletalLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 16,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingMessage;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColors.background.withOpacity(0.7),
            child: Center(
              child: AppLoading(
                message: loadingMessage ?? '加载中...',
                size: 32,
              ),
            ),
          ),
      ],
    );
  }
}