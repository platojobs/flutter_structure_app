class Validators {
  static bool isEmail(String? value) {
    if (value == null || value.isEmpty) return false;
    final emailReg = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}");
    return emailReg.hasMatch(value);
  }

  static bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

  static bool minLength(String? value, int length) => value != null && value.length >= length;

  static bool isPhone(String? value) {
    if (value == null || value.isEmpty) return false;
    final phoneReg = RegExp(r"^\+?[0-9]{7,15}");
    return phoneReg.hasMatch(value);
  }
}
