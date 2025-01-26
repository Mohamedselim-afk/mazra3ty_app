import 'package:get/get.dart';
import '../controllers/cycle_controller.dart';

class CycleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CycleController>(
      () => CycleController(),
    );
  }
}
