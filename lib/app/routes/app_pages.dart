import 'package:get/get.dart';
import 'package:mazra3ty_app/app/modules/cycles/controllers/expense_controller.dart';
import 'package:mazra3ty_app/app/modules/cycles/views/cycle_details_view.dart';
import '../modules/cycles/views/add_expense_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/cycles/bindings/cycle_binding.dart';
import '../modules/cycles/views/cycle_add_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/add-cycle',
      page: () => AddCycleView(),
      binding: CycleBinding(),
    ),
    GetPage(
      name: '/cycle-details/:id',
      page: () => CycleDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExpenseController());
      }),
    ),
    GetPage(
      name: '/add-expense',
      page: () => AddExpenseView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExpenseController());
      }),
    ),
  ];
}
