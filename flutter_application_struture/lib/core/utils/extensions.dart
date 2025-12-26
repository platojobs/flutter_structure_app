// lib/core/utils/extensions.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 通用扩展方法
extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  
  String? get orEmpty => this ?? '';
  
  String? get trimOrNull => this?.trim();
  
  bool get isValidEmail {
    if (isNullOrEmpty) return false;
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this!);
  }
  
  bool get isValidPhone {
    if (isNullOrEmpty) return false;
    return RegExp(
      r'^1[3-9]\d{9}$',
    ).hasMatch(this!);
  }
}

extension NumExtensions on num? {
  bool get isNullOrZero => this == null || this == 0;
  bool get isNotNullOrZero => !isNullOrZero;
}

extension ListExtensions<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  int get safeLength => this?.length ?? 0;
}

extension MapExtensions<K, V> on Map<K, V>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

extension ContextExtensions on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void showLoading() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  void hideLoading() {
    Navigator.of(this).pop();
  }
}

extension DateTimeExtensions on DateTime? {
  bool get isNullOrToday => this == null || 
    this!.isAtSameMomentAs(DateTime.now());
  
  bool get isBeforeToday => this == null || this!.isBefore(DateTime.now());
  
  bool get isAfterToday => this == null || this!.isAfter(DateTime.now());
  
  String get formatYMD => this != null ? 
    '${this!.year}-${this!.month.toString().padLeft(2, '0')}-${this!.day.toString().padLeft(2, '0')}' : '';
  
  String get formatYMDHM => this != null ?
    '${this!.year}-${this!.month.toString().padLeft(2, '0')}-${this!.day.toString().padLeft(2, '0')} '
    '${this!.hour.toString().padLeft(2, '0')}:${this!.minute.toString().padLeft(2, '0')}' : '';
}

extension RxExtensions<T> on Rx<T> {
  void updateIfNotNull() {
    if (this.value != null) {
      this.refresh();
    }
  }
}