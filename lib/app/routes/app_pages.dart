import 'package:get/get.dart';
import 'package:mazra3ty_app/app/modules/cycles/controllers/expense_controller.dart';
import 'package:mazra3ty_app/app/modules/cycles/views/cycle_details_view.dart';
import 'package:mazra3ty_app/app/modules/reports/controllers/report_controller.dart';
import 'package:mazra3ty_app/app/modules/reports/views/report_view.dart';
import '../modules/cycles/views/add_expense_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/cycles/bindings/cycle_binding.dart';
import '../modules/cycles/views/cycle_add_view.dart';

 final routes = [
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
    name: '/cycle/:id', 
    page: () => CycleDetailsView(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => ExpenseController());
    }),
  ),
  GetPage(
    name: '/add-expense/:cycleId',
    page: () => AddExpenseView(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => ExpenseController());
    }),
  ),
    GetPage(
    name: '/reports/:cycleId',
    page: () => ReportView(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => ReportController());
    }),
  ),

];