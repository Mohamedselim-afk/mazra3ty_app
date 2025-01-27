import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/cycle.dart';
import '../../../data/models/expense.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  final cycles = <Cycle>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadCycles();
  }

  void loadCycles() {
    try {
      final savedCycles = storage.read<List>('cycles') ?? [];
      cycles.assignAll(savedCycles.map((cycleData) {
        return Cycle(
          id: cycleData['id'],
          name: cycleData['name'],
          startDate: DateTime.parse(cycleData['startDate']),
          expectedSaleDate: DateTime.parse(cycleData['expectedSaleDate']),
          chicksCount: cycleData['chicksCount'],
          expenses: (cycleData['expenses'] as List).map((expenseData) {
            return Expense.fromJson(expenseData);
          }).toList(),
        );
      }).toList());
    } catch (e) {
      print('Error loading cycles: $e');
    }
  }

  void addNewCycle(Cycle cycle) {
    cycles.add(cycle);
    saveCycles();
    Get.back();
    Get.snackbar(
      'تم بنجاح',
      'تم إضافة الدورة ${cycle.name}',
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
    );
  }

  void updateCycle(Cycle updatedCycle) {
    final index = cycles.indexWhere((cycle) => cycle.id == updatedCycle.id);
    if (index != -1) {
      cycles[index] = updatedCycle;
      saveCycles();
    }
  }

  void saveCycles() {
    try {
      final cyclesData = cycles.map((cycle) => {
        'id': cycle.id,
        'name': cycle.name,
        'startDate': cycle.startDate.toIso8601String(),
        'expectedSaleDate': cycle.expectedSaleDate.toIso8601String(),
        'chicksCount': cycle.chicksCount,
        'expenses': cycle.expenses.map((expense) => expense.toJson()).toList(),
      }).toList();
      
      storage.write('cycles', cyclesData);
    } catch (e) {
      print('Error saving cycles: $e');
    }
  }

  void goToCycleDetails(String cycleId) {
    Get.toNamed(Routes.CYCLE_DETAILS, arguments: cycleId);
  }

  void deleteCycle(String cycleId) {
    cycles.removeWhere((cycle) => cycle.id == cycleId);
    saveCycles();
    Get.back();
    Get.snackbar(
      'تم الحذف',
      'تم حذف الدورة بنجاح',
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
    );
  }

  double getTotalExpenses(String cycleId) {
    final cycle = cycles.firstWhere((c) => c.id == cycleId);
    return cycle.expenses.fold(0, (sum, expense) => sum + expense.totalAmount);
  }

  double getTotalPaid(String cycleId) {
    final cycle = cycles.firstWhere((c) => c.id == cycleId);
    return cycle.expenses.fold(0, (sum, expense) => sum + expense.paidAmount);
  }
}
