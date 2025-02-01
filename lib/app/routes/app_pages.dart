import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/login/auth_controller.dart';
import '../modules/cycles/views/cycle_add_view.dart';
import '../modules/cycles/views/cycle_details_view.dart';
import '../modules/cycles/views/add_expense_view.dart';
import '../modules/cycles/bindings/cycle_binding.dart';
import '../modules/cycles/controllers/expense_controller.dart';
import '../modules/splash_screen/views/splash_view.dart';
import '../modules/splash_screen/bindings/splash_binding.dart';
import '../modules/market/views/market_view.dart';
import '../modules/market/bindings/market_binding.dart';
import '../modules/reports/views/report_view.dart';
import '../modules/reports/bindings/report_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),
    ),

    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.ADD_CYCLE,
      page: () => AddCycleView(),
      binding: CycleBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.CYCLE_DETAILS,
      page: () => CycleDetailsView(),
      binding: BindingsBuilder(() {
        Get.put(ExpenseController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.ADD_EXPENSE,
      page: () => AddExpenseView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExpenseController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.MARKET,
      page: () => MarketView(),
      binding: MarketBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.REPORTS,
      page: () => ReportView(),
      binding: ReportBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == Routes.LOGIN || route == Routes.SPLASH) {
      return null;
    }

    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn.value) {
      return RouteSettings(name: Routes.LOGIN);
    }
    return null;
  }
}