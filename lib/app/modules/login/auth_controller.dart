// lib/app/modules/auth/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../main.dart';
import '../../data/providers/remote_config.dart';

class AuthController extends GetxController {
  final RemoteConfigService _remoteConfig = RemoteConfigService();
  final _storage = GetStorage();
  final isLoading = false.obs;
  final isLoggedIn = false.obs;

  static const String STORAGE_KEY = 'access_code';


////////////////////////////////////////
  void main() {
  Get.put(AuthController(), permanent: true);
  runApp(MyApp());
}
//////////////////////////////////////////


  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final savedCode = _storage.read(STORAGE_KEY);
    if (savedCode != null) {
      isLoggedIn.value = await _verifyCode(savedCode);
      if (isLoggedIn.value) {
        Get.offAllNamed('/');
      }
    }
  }

  Future<void> verifyAccessCode(String code) async {
    if (code.isEmpty || code.length != 6) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال كود صحيح مكون من 6 أرقام',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // التحقق من وضع الصيانة
      await _remoteConfig.initialize();
      if (_remoteConfig.isMaintenanceMode) {
        Get.snackbar(
          'تنبيه',
          'التطبيق في وضع الصيانة حالياً، يرجى المحاولة لاحقاً',
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[800],
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final isValid = await _verifyCode(code);

      if (isValid) {
        await _storage.write(STORAGE_KEY, code);
        isLoggedIn.value = true;
        Get.offAllNamed('/');
      } else {
        Get.snackbar(
          'خطأ',
          'كود الدخول غير صحيح',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error in verifyAccessCode: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء التحقق من الكود',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _verifyCode(String code) async {
    try {
      final accessCodes = _remoteConfig.getAccessCodes();
      return accessCodes.values.contains(code);
    } catch (e) {
      print('Error in _verifyCode: $e');
      return false;
    }
  }

  void logout() {
    try {
      _storage.remove(STORAGE_KEY);
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error in logout: $e');
    }
  }
}