import 'package:mazra3ty_app/app/data/models/expense.dart';

class Cycle {
  String id;
  String name;
  DateTime startDate;
  DateTime expectedSaleDate;
  int chicksCount;
  List<Expense> expenses;

  Cycle({
    required this.id,
    required this.name,
    required this.startDate,
    required this.expectedSaleDate,
    required this.chicksCount,
    required this.expenses,
  });

  factory Cycle.fromJson(Map<String, dynamic> json) {
    return Cycle(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      expectedSaleDate: DateTime.parse(json['expectedSaleDate']),
      chicksCount: json['chicksCount'],
      expenses: (json['expenses'] as List)
          .map((e) => Expense.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name, 
    'startDate': startDate.toIso8601String(),
    'expectedSaleDate': expectedSaleDate.toIso8601String(),
    'chicksCount': chicksCount,
    'expenses': expenses.map((e) => e.toJson()).toList(),
  };

  double get totalExpenses => 
    expenses.fold(0, (sum, expense) => sum + expense.totalAmount);

  double get totalPaid =>
    expenses.fold(0, (sum, expense) => sum + expense.paidAmount);
    
  double get totalRemaining => totalExpenses - totalPaid;

  int get remainingDays => 
    expectedSaleDate.difference(DateTime.now()).inDays;

  double get progressPercentage {
    final totalDays = expectedSaleDate.difference(startDate).inDays;
    final passedDays = DateTime.now().difference(startDate).inDays;
    return (passedDays / totalDays).clamp(0.0, 1.0);
  }

  Cycle copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? expectedSaleDate,
    int? chicksCount,
    List<Expense>? expenses,
  }) => Cycle(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    expectedSaleDate: expectedSaleDate ?? this.expectedSaleDate,
    chicksCount: chicksCount ?? this.chicksCount,
    expenses: expenses ?? this.expenses,
  );
}