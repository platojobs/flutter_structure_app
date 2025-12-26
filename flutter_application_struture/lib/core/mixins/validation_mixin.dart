// lib/core/mixins/validation_mixin.dart
import 'package:get/get.dart';
import 'package:flutter_application_struture/core/utils/validators.dart';
import 'package:flutter_application_struture/core/utils/extensions.dart';

/// 表单验证混入
mixin ValidationMixin on GetxController {
  final Map<String, String> _errors = <String, String>{}.obs;

  /// 获取错误信息
  String? getError(String field) => _errors[field];

  /// 是否有错误
  bool hasError(String field) => _errors[field].isNotNullOrEmpty;

  /// 清除指定字段的错误
  void clearError(String field) {
    _errors.remove(field);
    _errors.refresh();
  }

  /// 清除所有错误
  void clearAllErrors() {
    _errors.clear();
    _errors.refresh();
  }

  /// 设置错误信息
  void setError(String field, String message) {
    _errors[field] = message;
    _errors.refresh();
  }

  /// 验证单个字段
  String? validateField(String field, String value, List<ValidationRule> rules) {
    clearError(field);
    
    for (final rule in rules) {
      final result = rule.validate(value);
      if (result.isNotNullOrEmpty) {
        setError(field, result);
        return result;
      }
    }
    
    return null;
  }

  /// 验证多个字段
  Map<String, String?> validateFields(Map<String, List<ValidationRule>> validations) {
    final errors = <String, String?>{};
    
    validations.forEach((field, rules) {
      final error = validateField(field, rules.first.value, rules);
      errors[field] = error;
    });
    
    return errors;
  }

  /// 通用验证方法
  bool validate(List<String> fields) {
    clearAllErrors();
    var isValid = true;
    
    for (final field in fields) {
      if (hasError(field)) {
        isValid = false;
      }
    }
    
    return isValid;
  }

  /// 邮箱验证
  String? validateEmail(String? email) {
    if (email.isNullOrEmpty) {
      return '请输入邮箱地址';
    }
    if (!email!.isValidEmail) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  /// 手机号验证
  String? validatePhone(String? phone) {
    if (phone.isNullOrEmpty) {
      return '请输入手机号';
    }
    if (!phone!.isValidPhone) {
      return '请输入有效的手机号';
    }
    return null;
  }

  /// 密码验证
  String? validatePassword(String? password, {int minLength = 6}) {
    if (password.isNullOrEmpty) {
      return '请输入密码';
    }
    if (password!.length < minLength) {
      return '密码长度不能少于$minLength位';
    }
    return null;
  }

  /// 确认密码验证
  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword.isNullOrEmpty) {
      return '请确认密码';
    }
    if (password != confirmPassword) {
      return '两次输入的密码不一致';
    }
    return null;
  }

  /// 非空验证
  String? validateRequired(String? value, {String fieldName = '该字段'}) {
    if (value.isNullOrEmpty) {
      return '$fieldName不能为空';
    }
    return null;
  }

  /// 长度验证
  String? validateLength(String? value, int min, int max, {String? fieldName}) {
    if (value.isNullOrEmpty) {
      return '${fieldName ?? '该字段'}不能为空';
    }
    if (value!.length < min) {
      return '${fieldName ?? '该字段'}长度不能少于$min位';
    }
    if (value.length > max) {
      return '${fieldName ?? '该字段'}长度不能超过$max位';
    }
    return null;
  }

  /// 数字验证
  String? validateNumber(String? value, {String? fieldName}) {
    if (value.isNullOrEmpty) {
      return '${fieldName ?? '该字段'}不能为空';
    }
    final number = int.tryParse(value!);
    if (number == null) {
      return '${fieldName ?? '请输入有效的数字'}';
    }
    return null;
  }

  /// URL验证
  String? validateUrl(String? url) {
    if (url.isNullOrEmpty) {
      return '请输入URL地址';
    }
    final uri = Uri.tryParse(url!);
    if (uri == null || !uri.hasAbsolutePath) {
      return '请输入有效的URL地址';
    }
    return null;
  }
}

/// 验证规则类
class ValidationRule {
  final String? value;
  final String Function(String) _validator;

  const ValidationRule(this.value, this._validator);

  String validate(String? input) => _validator(input ?? '');

  /// 必填验证
  static ValidationRule required({String? value, String? message}) {
    return ValidationRule(value, (input) {
      if (input.isEmpty) {
        return message ?? '该字段不能为空';
      }
      return '';
    });
  }

  /// 最小长度验证
  static ValidationRule minLength(int min, {String? value, String? message}) {
    return ValidationRule(value, (input) {
      if (input.length < min) {
        return message ?? '长度不能少于$min位';
      }
      return '';
    });
  }

  /// 最大长度验证
  static ValidationRule maxLength(int max, {String? value, String? message}) {
    return ValidationRule(value, (input) {
      if (input.length > max) {
        return message ?? '长度不能超过$max位';
      }
      return '';
    });
  }

  /// 邮箱验证
  static ValidationRule email({String? value, String? message}) {
    return ValidationRule(value, (input) {
      if (input.isEmpty) {
        return message ?? '请输入邮箱地址';
      }
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(input)) {
        return message ?? '请输入有效的邮箱地址';
      }
      return '';
    });
  }

  /// 手机号验证
  static ValidationRule phone({String? value, String? message}) {
    return ValidationRule(value, (input) {
      if (input.isEmpty) {
        return message ?? '请输入手机号';
      }
      if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(input)) {
        return message ?? '请输入有效的手机号';
      }
      return '';
    });
  }

  /// 数字验证
  static ValidationRule numeric({String? value, String? message}) {
    return ValidationRule(value, (input) {
      if (input.isEmpty) {
        return message ?? '请输入数字';
      }
      if (double.tryParse(input) == null) {
        return message ?? '请输入有效的数字';
      }
      return '';
    });
  }

  /// 正则表达式验证
  static ValidationRule regex(RegExp pattern, {String? value, String? message}) {
    return ValidationRule(value, (input) {
      if (!pattern.hasMatch(input)) {
        return message ?? '格式不正确';
      }
      return '';
    });
  }
}