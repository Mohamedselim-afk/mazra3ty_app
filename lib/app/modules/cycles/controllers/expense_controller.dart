import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazra3ty_app/app/modules/home/controllers/home_controller.dart';
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
    final homeController = Get.find<HomeController>();
    final cycle = homeController.cycles.firstWhere(
      (cycle) => cycle.id == cycleId.value,
    );
    expenses.assignAll(cycle.expenses);
  }

  // دالة إضافة مصروف جديد
  void addExpense(Expense expense) {
    final homeController = Get.find<HomeController>();
    final cycle = homeController.cycles.firstWhere((c) => c.id == cycleId.value);

    // التحقق من المبلغ المتوفر في الخزانة
    if (expense.paidAmount > cycle.treasuryAmount) {
      Get.snackbar(
        'خطأ',
        'المبلغ المدفوع أكبر من المبلغ المتوفر في الخزانة',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    // خصم المبلغ المدفوع من الخزانة
    cycle.treasuryAmount -= expense.paidAmount;
    cycle.expenses.add(expense);
    expenses.add(expense);
    homeController.updateCycle(cycle);

    Get.back();
    Get.snackbar(
      'تم بنجاح',
      'تم إضافة المصروف وخصم المبلغ من الخزانة',
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
    );
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
    
    // حساب الفرق في المبلغ المدفوع
    final paidDifference = newPaidAmount - expense.paidAmount;
    
    // التحقق من توفر المبلغ في الخزانة في حالة الزيادة
    if (paidDifference > 0 && paidDifference > cycle.treasuryAmount) {
      Get.snackbar(
        'خطأ',
        'المبلغ المدفوع الجديد يتجاوز المبلغ المتوفر في الخزانة',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    // تحديث رصيد الخزانة
    cycle.treasuryAmount -= paidDifference;
    
    // تحديث قيم المصروف
    expense.name = newName;
    expense.totalAmount = newTotalAmount;
    expense.paidAmount = newPaidAmount;
    expense.date = newDate;
    
    // تحديث البيانات
    expenses.refresh();
    homeController.updateCycle(cycle);

    Get.back();
    loadExpenses();

    Get.snackbar(
      'تم بنجاح',
      'تم تحديث المصروف والخزانة',
      backgroundColor: Colors.blue[100],
      colorText: Colors.blue[800],
    );
  }

  // دالة حذف المصروف
  void deleteExpense(Expense expense) {
    final homeController = Get.find<HomeController>();
    final cycle = homeController.cycles.firstWhere((c) => c.id == cycleId.value);

    // إعادة المبلغ المدفوع إلى الخزانة
    cycle.treasuryAmount += expense.paidAmount;

    // حذف المصروف
    cycle.expenses.remove(expense);
    expenses.remove(expense);

    homeController.updateCycle(cycle);

    Get.snackbar(
      'تم بنجاح',
      'تم حذف المصروف وإعادة المبلغ للخزانة',
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
    );
  }

  // دالة مساعدة للحصول على المبلغ المتبقي في الخزانة
  double getRemainingTreasury() {
    final homeController = Get.find<HomeController>();
    final cycle = homeController.cycles.firstWhere((c) => c.id == cycleId.value);
    return cycle.treasuryAmount;
  }
}