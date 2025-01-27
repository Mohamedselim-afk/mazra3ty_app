import 'package:get/get.dart';
import '../../../data/models/cycle.dart';

class HomeController extends GetxController {
  final cycles = <Cycle>[].obs;
  
  void addNewCycle(Cycle cycle) {
    cycles.add(cycle);
    // Add storage logic
  }

  void updateCycle(Cycle updatedCycle) {
    final index = cycles.indexWhere((cycle) => cycle.id == updatedCycle.id);
    if (index != -1) {
      cycles[index] = updatedCycle;
    }
  }

void goToCycleDetails(String cycleId) {
  Get.toNamed('/cycle/${cycleId}');
}
}

