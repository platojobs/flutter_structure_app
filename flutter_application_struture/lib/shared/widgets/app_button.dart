import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? child;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.child,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height,
  });

  factory AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
    double? height,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: _primaryButtonStyle(isEnabled),
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: width,
      height: height,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
    double? height,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: _secondaryButtonStyle(isEnabled),
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: width,
      height: height,
    );
  }

  factory AppButton.outline({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    IconData? icon,
    double? width,
    double? height,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: _outlineButtonStyle(isEnabled),
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: width,
      height: height,
    );
  }

  static ButtonStyle _primaryButtonStyle(bool isEnabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: isEnabled ? AppColors.primary : AppColors.textHint,
      foregroundColor: AppColors.white,
      elevation: isEnabled ? 2 : 0,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      minimumSize: const Size(0, 48),
    );
  }

  static ButtonStyle _secondaryButtonStyle(bool isEnabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: isEnabled ? AppColors.secondary : AppColors.textHint,
      foregroundColor: AppColors.white,
      elevation: isEnabled ? 2 : 0,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      minimumSize: const Size(0, 48),
    );
  }

  static ButtonStyle _outlineButtonStyle(bool isEnabled) {
    return OutlinedButton.styleFrom(
      foregroundColor: isEnabled ? AppColors.primary : AppColors.textHint,
      side: BorderSide(
        color: isEnabled ? AppColors.primary : AppColors.border,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      minimumSize: const Size(0, 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonChild = child ?? _buildButtonChild();

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: style ?? _primaryButtonStyle(isEnabled),
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: buttonChild,
        ),
      );
    }

    return ElevatedButton(
      style: style ?? _primaryButtonStyle(isEnabled),
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: buttonChild,
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final IconData? icon;
  final EdgeInsets? padding;

  const AppTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        textStyle: style,
      ),
    );
  }
}