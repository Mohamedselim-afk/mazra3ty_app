// lib/app/modules/market/bindings/market_binding.dart

import 'package:get/get.dart';
import '../../../data/providers/market_service.dart';
import '../controllers/market_controller.dart';

class MarketBinding extends Bindings {
  @override
  void dependencies() {
    // Register MarketService
    Get.lazyPut<MarketService>(
      () => MarketService(),
    );
    
    // Register MarketController with MarketService dependency
    Get.lazyPut<MarketController>(
      () => MarketController(),
    );
  }
}