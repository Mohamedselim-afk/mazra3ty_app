import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../data/models/expense.dart';

class ExpenseController extends GetxController {
  // تعريف expenses كـ RxList فارغة بدلاً من nullable
  final expenses = <Expense>[].obs;
  final cycleId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cycleId.value = Get.arguments;
    loadExpenses();
  }

  void loadExpenses() {
    // تنفيذ تحميل البيانات
  }

  void addExpense(Expense expense) {
    final existingIndex = expenses.indexWhere((e) => e.name == expense.name);
    
    if (existingIndex != -1) {
      final existing = expenses[existingIndex];
      expenses[existingIndex] = Expense(
        id: existing.id,
        name: existing.name,
        date: expense.date,
        totalAmount: existing.totalAmount + expense.totalAmount,
        paidAmount: existing.paidAmount + expense.paidAmount,
      );
    } else {
      expenses.add(expense);
    }
  }
}