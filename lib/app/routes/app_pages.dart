// lib/app/routes/app_pages.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/login/auth_controller.dart';
import '../modules/login/login_view.dart';
import '../modules/market/views/market_view.dart';
import '../modules/market/bindings/market_binding.dart';
import '../modules/cycles/views/cycle_add_view.dart';
import '../modules/cycles/views/cycle_details_view.dart';
import '../modules/cycles/views/add_expense_view.dart';
import '../modules/cycles/bindings/cycle_binding.dart';
import '../modules/cycles/controllers/expense_controller.dart';
import '../modules/reports/views/report_view.dart';
import '../modules/reports/bindings/report_binding.dart';
import '../modules/splash_screen/views/splash_view.dart';
import '../modules/splash_screen/bindings/splash_binding.dart';

abstract class Routes {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const HOME = '/';
  static const MARKET = '/market';
  static const ADD_CYCLE = '/add-cycle';
  static const CYCLE_DETAILS = '/cycle-details';
  static const ADD_EXPENSE = '/add-expense/:cycleId';
  static const REPORTS = '/reports';
}

class AppPages {
  static final routes = [
    // Splash Screen
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),

    // Login Page
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),

    // Home Page
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),

    // Market Page
    GetPage(
      name: Routes.MARKET,
      page: () => MarketView(),
      binding: MarketBinding(),
      middlewares: [AuthMiddleware()],
    ),

    // Add Cycle Page
    GetPage(
      name: Routes.ADD_CYCLE,
      page: () => AddCycleView(),
      binding: CycleBinding(),
      middlewares: [AuthMiddleware()],
    ),

    // Cycle Details Page
    GetPage(
      name: Routes.CYCLE_DETAILS,
      page: () => CycleDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExpenseController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    // Add Expense Page
    GetPage(
      name: Routes.ADD_EXPENSE,
      page: () => AddExpenseView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExpenseController());
      }),
      middlewares: [AuthMiddleware()],
    ),

    // Reports Page
    GetPage(
      name: Routes.REPORTS,
      page: () => ReportView(),
      binding: ReportBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // تخطي التحقق لصفحة تسجيل الدخول والـ splash
    if (route == Routes.LOGIN || route == Routes.SPLASH) {
      return null;
    }

    // التحقق من حالة تسجيل الدخول
    try {
      final authController = Get.find<AuthController>();
      if (!authController.isLoggedIn.value) {
        return RouteSettings(name: Routes.LOGIN);
      }
      return null;
    } catch (e) {
      // إذا لم يتم العثور على AuthController
      return RouteSettings(name: Routes.LOGIN);
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    return bindings;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }

  @override
  void onPageDispose() {
    // تنظيف الموارد إذا لزم الأمر
  }
}