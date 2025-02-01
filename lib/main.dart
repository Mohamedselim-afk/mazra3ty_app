// lib/main.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mazra3ty_app/app/data/providers/remote_config.dart';
import 'package:mazra3ty_app/app/modules/login/auth_controller.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';

// في main.dart

// في main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // اختبار الاتصال بدون إنشاء collection test
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('cycles').get();
      print('Firestore connection test successful');
    } catch (e) {
      print('Firestore test failed: $e');
    }

    await GetStorage.init();
    final remoteConfig = RemoteConfigService();
    await remoteConfig.initialize();
    
    runApp(MyApp());
  } catch (e) {
    print('Error in initialization: $e');
    runApp(ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'مزرعتي',
      debugShowCheckedModeBanner: false,
      
      // المسارات
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
    Get.put(AuthController(), permanent: true);
  }),

      
      // الثيم
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Cairo',
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      
      // دعم اللغة العربية
      locale: Locale('ar'),
      fallbackLocale: Locale('ar'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar'),
      ],
    );
  }
}

// تطبيق وضع الصيانة
class MaintenanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.build,
                size: 80,
                color: Colors.orange,
              ),
              SizedBox(height: 20),
              Text(
                'التطبيق في وضع الصيانة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'يرجى المحاولة لاحقاً',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      locale: Locale('ar'),
    );
  }
}

// تطبيق التحديث المطلوب
class UpdateRequiredApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.system_update,
                size: 80,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'يتوفر تحديث جديد',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'يرجى تحديث التطبيق للمتابعة',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // إضافة رابط متجر التطبيقات هنا
                },
                child: Text('تحديث الآن'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      locale: Locale('ar'),
    );
  }
}

// تطبيق الخطأ
class ErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'حدث خطأ غير متوقع',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'يرجى إعادة تشغيل التطبيق',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      locale: Locale('ar'),
    );
  }
}