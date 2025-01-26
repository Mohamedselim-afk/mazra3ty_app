class MarketPrice {
  String item; // كتاكيت، فراخ، علف
  double price;
  DateTime date;
  String source;

  MarketPrice({
    required this.item,
    required this.price,
    required this.date,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
    'item': item,
    'price': price,
    'date': date.toIso8601String(),
    'source': source,
  };
}
