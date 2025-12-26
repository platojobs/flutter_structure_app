class Email {
  final String _value;
  
  const Email(String value) : _value = value;
  
  String get value => _value;
  
  bool get isValid {
    if (_value.isEmpty) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(_value);
  }
  
  String? validate() {
    if (_value.isEmpty) return '邮箱地址不能为空';
    if (!isValid) return '请输入有效的邮箱地址';
    return null;
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Email && _value == other._value;
  
  @override
  int get hashCode => _value.hashCode;
  
  @override
  String toString() => _value;
}