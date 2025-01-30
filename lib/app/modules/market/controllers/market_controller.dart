import 'package:get/get.dart';
import '../../../data/models/market_price.dart';
import '../../../data/providers/market_service.dart';

class MarketController extends GetxController {
  final marketService = MarketService();
  final marketPrices = <MarketPrice>[].obs;
  final isLoading = true.obs;
  final error = RxString('');
  final showWebView = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMarketPrices();
    _startAutoRefresh();
  }

  void toggleView() {
    showWebView.toggle();
    if (!showWebView.value) {
      // Refresh native view when switching back
      loadMarketPrices();
    }
  }

  Future<void> loadMarketPrices() async {
    try {
      isLoading.value = true;
      error.value = '';
      final prices = await marketService.fetchPrices();
      marketPrices.assignAll(prices);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _startAutoRefresh() {
    ever(isLoading, (_) {
      if (!isLoading.value && !showWebView.value) {
        Future.delayed(Duration(minutes: 5), () {
          loadMarketPrices();
        });
      }
    });
  }
}