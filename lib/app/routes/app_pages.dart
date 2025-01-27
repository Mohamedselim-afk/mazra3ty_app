// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:mazra3ty_app/app/modules/reports/controllers/report_controller.dart';
import '../modules/cycles/controllers/expense_controller.dart';
import '../modules/cycles/views/cycle_details_view.dart';
import '../modules/cycles/views/add_expense_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/cycles/bindings/cycle_binding.dart';
import '../modules/cycles/views/cycle_add_view.dart';
import '../modules/reports/views/report_view.dart';

abstract class Routes {
  static const HOME = '/';
  static const ADD_CYCLE = '/add-cycle';
  static const CYCLE_DETAILS = '/cycle-details';
  static const ADD_EXPENSE = '/add-expense';
  static const REPORTS = '/reports';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ADD_CYCLE,
      page: () => AddCycleView(),
      binding: CycleBinding(),
    ),
    GetPage(
      name: Routes.CYCLE_DETAILS,
      page: () => CycleDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExpenseController());
      }),
    ),
    GetPage(
      name: Routes.ADD_EXPENSE,
      page: () => AddExpenseView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExpenseController());
      }),
    ),
    GetPage(
      name: Routes.REPORTS,
      page: () => ReportView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ReportController());
      }),
    ),
  ];
}