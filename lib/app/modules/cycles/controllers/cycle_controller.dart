import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazra3ty_app/app/modules/home/controllers/home_controller.dart' show HomeController;
import '../../../data/models/cycle.dart';

class CycleController extends GetxController {
  void addNewCycle(Cycle cycle) {
    final homeController = Get.find<HomeController>();
    homeController.addNewCycle(cycle);
    Get.back();
    Get.snackbar(
      'تم بنجاح',
      'تم إنشاء الدورة ${cycle.name}',
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
    );
  }
}
