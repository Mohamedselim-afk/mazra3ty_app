// lib/app/data/models/market_price.dart

class MarketPrice {
  final String item;      // اسم السلعة
  final double price;     // السعر
  final String change;    // التغيير
  final DateTime date;    // تاريخ التحديث
  final String source;    // مصدر السعر

  MarketPrice({
    required this.item,
    required this.price,
    required this.change,
    required this.date,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
    'item': item,
    'price': price,
    'change': change,
    'date': date.toIso8601String(),
    'source': source,
  };

  factory MarketPrice.fromJson(Map<String, dynamic> json) => MarketPrice(
    item: json['item'],
    price: json['price'],
    change: json['change'],
    date: DateTime.parse(json['date']),
    source: json['source'],
  );
}