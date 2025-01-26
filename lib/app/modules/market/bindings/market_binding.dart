import 'package:get/get.dart';
import '../controllers/market_controller.dart';

class MarketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketController>(
      () => MarketController(),
    );
  }
}
