class CycleReport {
  final String cycleId;
  final String cycleName;
  final DateTime startDate;
  final DateTime expectedEndDate;
  final int chicksCount;
  final double treasuryAmount;
  final List<ExpenseReport> expenses;
  
  // إضافة الحقول الجديدة
  double totalRevenue; // المكسب الكلي
  double totalWeight; // الوزن الكلي
  
  // حسابات المصروفات
  double get totalExpenses => expenses.fold(0, (sum, exp) => sum + exp.totalAmount);
  double get totalPaid => expenses.fold(0, (sum, exp) => sum + exp.paidAmount);
  double get totalRemaining => totalExpenses - totalPaid;
  double get remainingTreasury => treasuryAmount - totalPaid;
  
  // حسابات الأرباح
  double get netProfit => totalRevenue - totalExpenses; // الربح الصافي
  double get pricePerKilo => totalWeight > 0 ? totalRevenue / totalWeight : 0; // السعر للكيلو
  double get averageChickWeight => totalWeight > 0 ? totalWeight / chicksCount : 0; // متوسط وزن الكتكوت

  CycleReport({
    required this.cycleId,
    required this.cycleName,
    required this.startDate,
    required this.expectedEndDate,
    required this.chicksCount,
    required this.treasuryAmount,
    required this.expenses,
    this.totalRevenue = 0,
    this.totalWeight = 0,
  });

  // نسخة معدلة من الكائن مع تحديث المكسب والوزن
  CycleReport copyWithFinancials({
    required double totalRevenue,
    required double totalWeight,
  }) {
    return CycleReport(
      cycleId: this.cycleId,
      cycleName: this.cycleName,
      startDate: this.startDate,
      expectedEndDate: this.expectedEndDate,
      chicksCount: this.chicksCount,
      treasuryAmount: this.treasuryAmount,
      expenses: this.expenses,
      totalRevenue: totalRevenue,
      totalWeight: totalWeight,
    );
  }
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