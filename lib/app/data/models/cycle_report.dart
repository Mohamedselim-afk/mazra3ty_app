// lib/app/data/models/cycle_report.dart
class CycleReport {
  final String cycleId;
  final String cycleName;
  final DateTime startDate;
  final DateTime expectedEndDate;
  final int chicksCount;
    final double treasuryAmount; // إضافة قيمة الخزانة

  final List<ExpenseReport> expenses;
  
  double get totalExpenses => expenses.fold(0, (sum, exp) => sum + exp.totalAmount);
  double get totalPaid => expenses.fold(0, (sum, exp) => sum + exp.paidAmount);
  double get totalRemaining => totalExpenses - totalPaid;
    double get remainingTreasury => treasuryAmount - totalPaid; // إضافة getter للمبلغ المتبقي في الخزانة


  CycleReport({
    required this.cycleId,
    required this.cycleName,
    required this.startDate,
    required this.expectedEndDate,
    required this.chicksCount,
        required this.treasuryAmount, // إضافة في constructor

    required this.expenses,
  });
}

class ExpenseReport {
  final String name;
  final DateTime date;
  final double totalAmount;
  final double paidAmount;

  ExpenseReport({
    required this.name,
    required this.date,
    required this.totalAmount,
    required this.paidAmount,
  });
}