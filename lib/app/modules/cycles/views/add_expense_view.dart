import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/expense.dart';
import '../controllers/expense_controller.dart';

class AddExpenseView extends GetView<ExpenseController> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final totalController = TextEditingController();
  final paidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مصروفات'),
        backgroundColor: Colors.green[600],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'اسم الصنف',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.shopping_cart),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'التاريخ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  dateController.text = date.toString().split(' ')[0];
                }
              },
              validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: totalController,
              decoration: InputDecoration(
                labelText: 'السعر الكلي',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.attach_money),
                suffixText: 'ج.م',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'مطلوب';
                if (double.tryParse(value!) == null) return 'أدخل رقم صحيح';
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: paidController,
              decoration: InputDecoration(
                labelText: 'المبلغ المدفوع',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.payments),
                suffixText: 'ج.م',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'مطلوب';
                if (double.tryParse(value!) == null) return 'أدخل رقم صحيح';
                final paid = double.parse(value);
                final total = double.parse(totalController.text);
                if (paid > total) return 'المبلغ المدفوع أكبر من السعر الكلي';
                return null;
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
  onPressed: () {
    if (formKey.currentState!.validate()) {
      final expense = Expense(
        id: DateTime.now().toString(),
        name: nameController.text,
        date: DateTime.parse(dateController.text),
        totalAmount: double.parse(totalController.text),
        paidAmount: double.parse(paidController.text),
      );
      controller.addExpense(expense);
      Get.back(); // العودة إلى الصفحة السابقة بعد الإضافة
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green[600],
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text(
    'إضافة المصروف',
    style: TextStyle(fontSize: 18),
  ),
),
          ],
        ),
      ),
    );
  }
}
