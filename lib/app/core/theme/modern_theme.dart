// lib/app/core/theme/modern_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernTheme {
  // ألوان رئيسية جديدة
  static const primaryGradient = LinearGradient(
    colors: [
      Color(0xFF2AAF61),
      Color(0xFF147B40),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [
      Color(0xFF1E88E5),
      Color(0xFF1565C0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // نمط النصوص
  static final titleStyle = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final subtitleStyle = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static final bodyStyle = GoogleFonts.cairo(
    fontSize: 16,
    color: Colors.black87,
  );

  // نمط البطاقات
  static final modernCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  );

  // نمط البطاقات الزجاجية
  static final glassCardDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.white.withOpacity(0.4),
        Colors.white.withOpacity(0.2),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  );

  // نمط الأزرار
  static final modernButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 8,
  );

  // نمط حقول الإدخال
  static final modernInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Color(0xFF2AAF61), width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintStyle: GoogleFonts.cairo(
      color: Colors.grey[400],
    ),
  );

  // خلفية متدرجة متحركة
  static final animatedBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFF3F4F6),
        Colors.white,
        Color(0xFFF3F4F6),
      ],
    ),
  );
}

// Animated Container Mixin
mixin AnimatedContainerMixin {
  Animation<double> getSlideAnimation(AnimationController controller, {double from = 100}) {
    return Tween<double>(
      begin: from,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Animation<double> getFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
  }
}