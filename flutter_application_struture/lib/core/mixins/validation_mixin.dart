// lib/core/mixins/validation_mixin.dart
import 'package:flutter_application_struture/core/base/base_controller.dart';
import 'package:get/get.dart';

/// 表单验证混入
mixin OptionalValidationMixin<T> on BaseController<T> {
  final _validators = <String, String? Function(String?)>{};
  final _formErrors = <String, String?>{}.obs;
  
  /// 添加验证规则
  void addValidator(String field, String? Function(String?) validator) {
    if (!config.enableValidation) return;
    _validators[field] = validator;
  }
  
  /// 验证字段
  String? validateField(String field, String? value) {
    if (!config.enableValidation) return null;
    return _validators[field]?.call(value);
  }
  
  /// 验证表单
  Map<String, String?> validateForm(Map<String, String?> fields) {
    if (!config.enableValidation) return {};
    
    final errors = <String, String?>{};
    for (final entry in fields.entries) {
      final error = validateField(entry.key, entry.value);
      if (error != null) {
        errors[entry.key] = error;
      }
    }
    
    _formErrors.value = errors;
    return errors;
  }
  
  /// 是否验证通过
  bool isValid(Map<String, String?> fields) {
    return validateForm(fields).isEmpty;
  }
  
  /// 内置验证规则
  static String? required(String? value, {String fieldName = '字段'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName不能为空';
    }
    return null;
  }
  
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return '邮箱格式不正确';
    }
    return null;
  }
  
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return '手机号格式不正确';
    }
    return null;
  }
}