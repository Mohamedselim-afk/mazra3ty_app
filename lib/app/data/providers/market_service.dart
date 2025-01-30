import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../models/market_price.dart';

class MarketService {
  static const String baseUrl = 'https://mazra3ty.com/boursa';
  
  Future<List<MarketPrice>> fetchPrices() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        final document = parse(response.body);
        final prices = <MarketPrice>[];
        
        // كتاكيت
        _extractPrices(document, 'كتاكيت', prices);
        
        // فراخ
        _extractPrices(document, 'فراخ', prices);
        
        // علف
        _extractPrices(document, 'علف', prices);
        
        return prices;
      }
      
      throw Exception('فشل تحميل الأسعار');
    } catch (e) {
      throw Exception('حدث خطأ أثناء تحميل الأسعار: $e');
    }
  }
  
  void _extractPrices(document, String category, List<MarketPrice> prices) {
    try {
      // تعديل السيليكتور حسب هيكل الموقع
      final elements = document.querySelectorAll('.price-item');
      
      for (var element in elements) {
        final price = MarketPrice(
          item: category,
          price: _extractPrice(element),
          change: _extractChange(element),
          date: DateTime.now(),
          source: _extractSource(element),
        );
        
        prices.add(price);
      }
    } catch (e) {
      print('خطأ في استخراج أسعار $category: $e');
    }
  }
  
  double _extractPrice(element) {
    try {
      final priceText = element.querySelector('.price')?.text ?? '0';
      return double.tryParse(priceText.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
  
  String _extractChange(element) {
    try {
      final change = element.querySelector('.change')?.text ?? '0';
      if (change.contains('-')) {
        return change;
      } else if (change != '0') {
        return '+$change';
      }
      return change;
    } catch (e) {
      return '0';
    }
  }
  
  String _extractSource(element) {
    try {
      return element.querySelector('.source')?.text ?? 'بورصة الدواجن';
    } catch (e) {
      return 'بورصة الدواجن';
    }
  }
}