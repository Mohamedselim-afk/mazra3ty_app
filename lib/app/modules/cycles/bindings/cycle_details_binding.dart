import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:mazra3ty_app/app/modules/cycles/controllers/expense_controller.dart';

class CycleDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ExpenseController(), permanent: true);
  }
}
