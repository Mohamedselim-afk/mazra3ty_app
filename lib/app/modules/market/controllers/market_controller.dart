import 'package:get/get.dart';
import '../../../data/models/market_price.dart';

class MarketController extends GetxController {
  final marketPrices = <MarketPrice>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMarketPrices();
  }

  void loadMarketPrices() {
    // Load from API or local storage
  }

  void addMarketPrice(MarketPrice price) {
    marketPrices.add(price);
    // Save to storage
  }
}
