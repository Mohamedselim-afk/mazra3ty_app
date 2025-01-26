import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mazra3ty_app/app/modules/home/controllers/home_controller.dart';

import '../../../data/models/expense.dart';

class ExpenseController extends GetxController {
  final expenses = <Expense>[].obs;
  final cycleId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cycleId.value = Get.arguments;
    loadExpenses();
  }

  void loadExpenses() {
    // تنفيذ تحميل البيانات من الدورة المحددة
    final homeController = Get.find<HomeController>();
    final cycle = homeController.cycles.firstWhere((cycle) => cycle.id == cycleId.value);
    expenses.assignAll(cycle.expenses);
  }

  void addExpense(Expense expense) {
    final homeController = Get.find<HomeController>();
    final cycle = homeController.cycles.firstWhere((cycle) => cycle.id == cycleId.value);
    
    cycle.expenses.add(expense);
    expenses.add(expense);
    
    // تحديث الدورة في HomeController
    homeController.updateCycle(cycle);
  }
}
