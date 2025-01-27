import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/cycle.dart';
import '../../../data/providers/storage_provider.dart';

class HomeController extends GetxController {
  final storageProvider = StorageProvider();
  final cycles = <Cycle>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadCycles();
  }

  Future<void> loadCycles() async {
    try {
      final loadedCycles = await storageProvider.loadCycles();
      cycles.assignAll(loadedCycles);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  void goToCycleDetails(String cycleId) {
    Get.toNamed('/cycle-details', arguments: cycleId);
  }

  Future<void> addNewCycle(Cycle cycle) async {
    try {
      cycles.add(cycle);
      await storageProvider.saveCycles(cycles);
      Get.back();
      Get.snackbar(
        'تم بنجاح',
        'تم إضافة الدورة ${cycle.name}',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حفظ البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> updateCycle(Cycle updatedCycle) async {
    try {
      final index = cycles.indexWhere((cycle) => cycle.id == updatedCycle.id);
      if (index != -1) {
        cycles[index] = updatedCycle;
        await storageProvider.saveCycles(cycles);
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> deleteCycle(String cycleId) async {
    try {
      cycles.removeWhere((cycle) => cycle.id == cycleId);
      await storageProvider.saveCycles(cycles);
      Get.snackbar(
        'تم الحذف',
        'تم حذف الدورة بنجاح',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }
}