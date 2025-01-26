import 'package:get/get.dart';
import '../../../data/models/cycle.dart';

class HomeController extends GetxController {
  final cycles = <Cycle>[].obs;
  
  void addNewCycle(Cycle cycle) {
    cycles.add(cycle);
    // Add storage logic
  }

  void goToCycleDetails(String cycleId) {
    Get.toNamed('/cycle-details', arguments: cycleId);
  }
}
