import 'package:mazra3ty_app/app/data/models/expense.dart';

class Cycle {
  String id;
  String name;
  DateTime startDate;
  DateTime expectedSaleDate;
  int chicksCount;
  List<Expense> expenses;
    double treasuryAmount; // إضافة قيمة الخزانة


  Cycle({
    required this.id,
    required this.name,
    required this.startDate,
    required this.expectedSaleDate,
    required this.chicksCount,
    required this.expenses,
        required this.treasuryAmount, // إضافة في constructor

  });

  // إضافة getters لحساب القيم المطلوبة
  double get totalExpenses => 
    expenses.fold(0, (sum, expense) => sum + expense.totalAmount);

  double get totalPaid =>
    expenses.fold(0, (sum, expense) => sum + expense.paidAmount);
    
  double get totalRemaining => totalExpenses - totalPaid;

    // إضافة getter لحساب المبلغ المتبقي في الخزانة
  double get remainingTreasury => 
    treasuryAmount - totalPaid;


  int get remainingDays => 
    expectedSaleDate.difference(DateTime.now()).inDays;

  double get progressPercentage {
    final totalDays = expectedSaleDate.difference(startDate).inDays;
    final passedDays = DateTime.now().difference(startDate).inDays;
    return (passedDays / totalDays).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    try {
      print('Converting cycle to JSON - ID: $id');
      final json = {
        'id': id,
        'name': name,
        'startDate': startDate.toIso8601String(),
        'expectedSaleDate': expectedSaleDate.toIso8601String(),
        'chicksCount': chicksCount,
        'expenses': expenses.map((e) => e.toJson()).toList(),
                'treasuryAmount': treasuryAmount, // إضافة في التحويل إلى JSON

      };
      print('Successfully converted to JSON: $json');
      return json;
    } catch (e) {
      print('Error converting cycle to JSON: $e');
      rethrow;
    }
  }

  factory Cycle.fromJson(Map<String, dynamic> json) {
    try {
      print('Creating cycle from JSON: $json');
      return Cycle(
        id: json['id'] as String,
        name: json['name'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        expectedSaleDate: DateTime.parse(json['expectedSaleDate'] as String),
        chicksCount: json['chicksCount'] as int,
                treasuryAmount: (json['treasuryAmount'] as num?)?.toDouble() ?? 0.0, // إضافة في التحويل من JSON
        expenses: (json['expenses'] as List? ?? [])
            .map((e) => Expense.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      print('Error creating cycle from JSON: $e');
      rethrow;
    }
  }

  Cycle copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? expectedSaleDate,
    int? chicksCount,
    List<Expense>? expenses,
        double? treasuryAmount, // إضافة في copyWith

  }) => Cycle(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    expectedSaleDate: expectedSaleDate ?? this.expectedSaleDate,
    chicksCount: chicksCount ?? this.chicksCount,
    expenses: expenses ?? this.expenses,
        treasuryAmount: treasuryAmount ?? this.treasuryAmount, // إضافة في return

  );
}