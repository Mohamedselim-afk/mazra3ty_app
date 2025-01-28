// lib/app/core/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // الألوان الرئيسية
  static final primaryColor = Colors.green[600]!;
  static final secondaryColor = Colors.green[800]!;
  static final backgroundColor = Colors.grey[50]!;
  
  // ألوان الحالة
  static final successColor = Colors.green[100]!;
  static final successTextColor = Colors.green[800]!;
  static final errorColor = Colors.red[100]!;
  static final errorTextColor = Colors.red[800]!;
  static final warningColor = Colors.orange[100]!;
  static final warningTextColor = Colors.orange[800]!;

  // نمط البطاقات
  static final cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  // نمط الأزرار
  static final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // نمط حقول الإدخال
  static final inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColor),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  // نمط النصوص
  static const titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const bodyStyle = TextStyle(
    fontSize: 16,
  );

  // تدرج الخلفية
  static final backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.green[50]!,
      Colors.white,
    ],
  );
}