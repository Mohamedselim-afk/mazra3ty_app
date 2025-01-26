class Expense {
  String id;
  String name;
  DateTime date;
  double totalAmount;
  double paidAmount;
  double remainingAmount;

  Expense({
    required this.id,
    required this.name, 
    required this.date,
    required this.totalAmount,
    required this.paidAmount,
  }) : remainingAmount = totalAmount - paidAmount;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    name: json['name'],
    date: DateTime.parse(json['date']),
    totalAmount: json['totalAmount'].toDouble(),
    paidAmount: json['paidAmount'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date': date.toIso8601String(),
    'totalAmount': totalAmount,
    'paidAmount': paidAmount,
    'remainingAmount': remainingAmount,
  };

  Expense copyWith({
    String? id,
    String? name,
    DateTime? date,
    double? totalAmount, 
    double? paidAmount,
  }) => Expense(
    id: id ?? this.id,
    name: name ?? this.name,
    date: date ?? this.date,
    totalAmount: totalAmount ?? this.totalAmount,
    paidAmount: paidAmount ?? this.paidAmount,
  );
}