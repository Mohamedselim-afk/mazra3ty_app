// lib/app/modules/splash/views/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/splash_controller.dart';
import '../../../core/theme/modern_theme.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.green[400]!,
              Colors.green[700]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Obx(
                  () => AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: controller.animationCompleted.value ? 0.0 : 1.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // لوجو التطبيق
                        FadeInDown(
                          duration: Duration(milliseconds: 1500),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.eco,
                              size: 80,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        
                        // اسم التطبيق
                        FadeInUp(
                          delay: Duration(milliseconds: 500),
                          duration: Duration(milliseconds: 1500),
                          child: Text(
                            "مزرعتي",
                            style: ModernTheme.titleStyle.copyWith(
                              fontSize: 48,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // وصف التطبيق
                        FadeInUp(
                          delay: Duration(milliseconds: 1000),
                          duration: Duration(milliseconds: 1500),
                          child: Text(
                            "إدارة مزرعتك بسهولة وذكاء",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 60),
                        
                        // انيميشن التحميل
                        SpinPerfect(
                          infinite: true,
                          duration: Duration(seconds: 2),
                          child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // رسومات خلفية متحركة
              ...List.generate(20, (index) => _buildFloatingLeaf(index)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingLeaf(int index) {
    final random = index * 20.0;
    return Positioned(
      left: random * 2,
      top: random * 3 % Get.height,
      child: FadeInDown(
        delay: Duration(milliseconds: index * 100),
        duration: Duration(milliseconds: 2000),
        child: SpinPerfect(
          infinite: true,
          duration: Duration(seconds: 3 + index % 3),
          child: Opacity(
            opacity: 0.2,
            child: Icon(
              Icons.eco,
              size: 20.0 + index % 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
