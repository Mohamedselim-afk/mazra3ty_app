import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/providers/market_service.dart';
import '../controllers/market_controller.dart';

class MarketView extends GetView<MarketController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بورصة الأسعار', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[600],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: controller.loadMarketPrices,
          ),
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () => controller.toggleView(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.showWebView.value) {
          return _buildWebView();
        }
        
        return _buildNativeView();
      }),
    );
  }

Widget _buildWebView() {
    late final WebViewController webViewController;
    
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
      ..loadRequest(Uri.parse(MarketService.baseUrl))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            controller.isLoading.value = true;
          },
          onPageFinished: (String url) async {
            await webViewController.runJavaScript('''
              if (!document.querySelector('meta[name="viewport"]')) {
                var meta = document.createElement('meta');
                meta.name = 'viewport';
                meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                document.getElementsByTagName('head')[0].appendChild(meta);
              }
            ''');
            controller.isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            controller.error.value = 'فشل تحميل الموقع: ${error.description}';
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setUserAgent('Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36');

    return WebViewWidget(controller: webViewController);
  }




  Widget _buildNativeView() {
    if (controller.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    if (controller.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
            SizedBox(height: 16),
            Text(
              controller.error.value,
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.loadMarketPrices,
              child: Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green[50]!, Colors.white],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: controller.loadMarketPrices,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildLastUpdateCard(),
            SizedBox(height: 16),
            _buildPriceSection('كتاكيت', Icons.pets),
            _buildPriceSection('فراخ', Icons.egg),
            _buildPriceSection('علف', Icons.grass),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdateCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.update, color: Colors.green[600]),
            SizedBox(width: 8),
            Text(
              'آخر تحديث: ${_getLastUpdateTime()}',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLastUpdateTime() {
    if (controller.marketPrices.isEmpty) return 'لا يوجد';
    final lastUpdate = controller.marketPrices.first.date;
    return '${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildPriceSection(String category, IconData icon) {
    final prices = controller.marketPrices
        .where((price) => price.item == category)
        .toList();

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.green[600]),
                SizedBox(width: 8),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...prices.map(
            (price) => Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${price.price} ج.م',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        price.source,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  _buildPriceChange(price.change),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChange(String change) {
    final isPositive = change.startsWith('+');
    final color = isPositive ? Colors.green : Colors.red;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 16,
            color: color[700],
          ),
          SizedBox(width: 4),
          Text(
            change,
            style: TextStyle(
              color: color[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}