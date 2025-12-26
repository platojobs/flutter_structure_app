class Password {
  final String _value;
  
  const Password(String value) : _value = value;
  
  String get value => _value;
  
  bool get isValid {
    if (_value.isEmpty) return false;
    if (_value.length < 6) return false;
    return true;
  }
  
  String? validate() {
    if (_value.isEmpty) return '密码不能为空';
    if (_value.length < 6) return '密码长度至少6位';
    return null;
  }
  
  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(_value);
  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(_value);
  bool get hasNumber => RegExp(r'[0-9]').hasMatch(_value);
  bool get hasSpecialChar => RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_value);
  
  int get strength {
    int score = 0;
    if (_value.length >= 8) score++;
    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasNumber) score++;
    if (hasSpecialChar) score++;
    return score;
  }
  
  String get strengthText {
    switch (strength) {
      case 0:
      case 1:
        return '弱';
      case 2:
      case 3:
        return '中等';
      case 4:
      case 5:
        return '强';
      default:
        return '未知';
    }
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Password && _value == other._value;
  
  @override
  int get hashCode => _value.hashCode;
  
  @override
  String toString() => _value;
}