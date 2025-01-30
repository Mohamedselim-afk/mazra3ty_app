import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mazra3ty_app/app/modules/home/controllers/home_controller.dart';
import 'package:mazra3ty_app/app/modules/reports/controllers/report_controller.dart';

import '../../../data/models/expense.dart';
import '../../../routes/app_pages.dart';

class ExpenseController extends GetxController {
  final expenses = <Expense>[].obs;
  final cycleId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cycleId.value = Get.arguments as String;
    loadExpenses();
  }

  void loadExpenses() {
    // تنفيذ تحميل البيانات من الدورة المحددة
    final homeController = Get.find<HomeController>();
    final cycle = homeController.cycles.firstWhere(
      (cycle) => cycle.id == cycleId.value,
    );
    expenses.assignAll(cycle.expenses);
  }

  void addExpense(Expense expense) {
    final homeController = Get.find<HomeController>();
    final cycle =
        homeController.cycles.firstWhere((c) => c.id == cycleId.value);

    cycle.expenses.add(expense);
    expenses.add(expense);
    homeController.updateCycle(cycle);
    Get.back();

    Get.snackbar(
      'تم بنجاح',
      'تم إضافة المصروف',
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
    );

    // Get.toNamed(Routes.REPORTS, arguments: cycleId.value);
    // final reportController = Get.put(ReportController());
    // reportController.generatePDF();
  }

  // دالة تحديث المصروف
void updateExpense(Expense expense, {
  required String newName,
  required double newTotalAmount,
  required double newPaidAmount,
  required DateTime newDate,
}) {
  final homeController = Get.find<HomeController>();
  final cycle = homeController.cycles.firstWhere((c) => c.id == cycleId.value);
  
  // تحديث جميع قيم المصروف
  expense.name = newName;
  expense.totalAmount = newTotalAmount;
  expense.paidAmount = newPaidAmount;
  expense.date = newDate;
  
  // تحديث القائمة المحلية والدورة
  expenses.refresh();
  homeController.updateCycle(cycle);

  // العودة للشاشة السابقة
  Get.back();
  loadExpenses(); // إعادة تحميل البيانات

  Get.snackbar(
    'تم بنجاح',
    'تم تحديث المصروف',
    backgroundColor: Colors.blue[100],
    colorText: Colors.blue[800],
  );
}

  // دالة حذف المصروف
  void deleteExpense(Expense expense) {
    final homeController = Get.find<HomeController>();
    final cycle =
        homeController.cycles.firstWhere((c) => c.id == cycleId.value);

    // حذف المصروف من القائمة المحلية والدورة
    cycle.expenses.remove(expense);
    expenses.remove(expense);

    homeController.updateCycle(cycle);

    Get.snackbar(
      'تم بنجاح',
      'تم حذف المصروف',
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
    );
  }
}
