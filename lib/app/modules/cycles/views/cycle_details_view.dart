import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/expense.dart';
import '../controllers/expense_controller.dart';

class CycleDetailsView extends GetView<ExpenseController> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الدورة'),
        backgroundColor: Colors.green[600],
      ),
      body: Column(
        children: [_buildCycleSummary(), Expanded(child: _buildExpensesList())],
      ),
floatingActionButton: FloatingActionButton(
  onPressed: () => Get.toNamed('/add-expense', arguments: controller.cycleId.value),
  backgroundColor: Colors.green[600],
  child: Icon(Icons.add),
),    );
  }

  Widget _buildCycleSummary() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إجمالي المصروفات',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Obx(() {
                  final total = controller.expenses.fold<double>(
                    0,
                    (sum, expense) => sum + expense.totalAmount,
                  );
                  return Text(
                    '$total ج.م',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إجمالي المدفوع',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Obx(() {
                  final paid = controller.expenses.fold<double>(
                    0,
                    (sum, expense) => sum + expense.paidAmount,
                  );
                  return Text(
                    '$paid ج.م',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إجمالي المتبقي',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Obx(() {
                  final remaining = controller.expenses.fold<double>(
                    0,
                    (sum, expense) => sum + expense.remainingAmount,
                  );
                  return Text(
                    '$remaining ج.م',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList() {
    return Obx(() {
      if (controller.expenses.isEmpty) {
        return Center(
          child: Text(
            'لا توجد مصروفات',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        );
      }

      final groupedExpenses = <String, List<Expense>>{};
      for (var expense in controller.expenses) {
        if (!groupedExpenses.containsKey(expense.name)) {
          groupedExpenses[expense.name] = [];
        }
        groupedExpenses[expense.name]!.add(expense);
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: groupedExpenses.length,
        itemBuilder: (context, index) {
          final name = groupedExpenses.keys.elementAt(index);
          final expenses = groupedExpenses[name]!;
          final totalAmount = expenses.fold<double>(
            0,
            (sum, expense) => sum + expense.totalAmount,
          );
          final paidAmount = expenses.fold<double>(
            0,
            (sum, expense) => sum + expense.paidAmount,
          );
          final remainingAmount = totalAmount - paidAmount;

          return Card(
  margin: EdgeInsets.only(bottom: 8),
  child: ExpansionTile(
    title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(
      'المتبقي: $remainingAmount ج.م',
      style: TextStyle(color: Colors.red),
    ),
    children: expenses
      .map((expense) => ListTile(
        title: Text(expense.date.toString().split(' ')[0]),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'الكلي: ${expense.totalAmount.toStringAsFixed(2)} ج.م',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'المدفوع: ${expense.paidAmount.toStringAsFixed(2)} ج.م',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ))
      .toList(),
  ),
);
        },
      );
    });
  }
}
