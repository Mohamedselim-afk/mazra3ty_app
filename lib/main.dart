import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazra3ty_app/app/routes/app_pages.dart';
import 'app/routes/app_pages.dart';



// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// // ...

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "مزرعتي",
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      locale: Locale('ar'),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    ),
  );
}
