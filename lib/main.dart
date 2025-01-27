import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazra3ty_app/app/routes/app_pages.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "مزرعتي",
      initialRoute: '/',
      getPages: AppPages.routes,
      locale: Locale('ar'),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    ),
  );
}
