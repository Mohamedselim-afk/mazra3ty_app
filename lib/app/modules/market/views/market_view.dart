import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/market_controller.dart';

class MarketView extends GetView<MarketController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بورصة الأسعار', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[600],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: Obx(
          () => ListView(
            padding: EdgeInsets.all(16),
            children: [
              _buildPriceSection('كتاكيت', Icons.pets),
              _buildPriceSection('فراخ', Icons.egg),
              _buildPriceSection('علف', Icons.grass),
            ],
          ),
        ),
      ),
    );
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
                Spacer(),
                Text(
                  'آخر تحديث: ${prices.isEmpty ? '-' : prices.last.date.toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.grey[600]),
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      price.date.toString().split(' ')[0],
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
