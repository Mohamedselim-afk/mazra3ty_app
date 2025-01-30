// lib/app/modules/splash/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController {
  final isLoading = true.obs;
  final animationCompleted = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  void startAnimation() async {
    // تشغيل الانيميشن لمدة 3 ثواني
    await Future.delayed(Duration(seconds: 5));
    animationCompleted.value = true;
    
    // الانتقال إلى الصفحة الرئيسية
    await Future.delayed(Duration(milliseconds: 500));
    Get.offAllNamed('/');
  }
}
