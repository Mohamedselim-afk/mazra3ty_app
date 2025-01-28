import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../data/models/expense.dart';
import '../controllers/expense_controller.dart';
import '../../../core/theme/modern_theme.dart';

class AddExpenseView extends GetView<ExpenseController> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final totalController = TextEditingController();
  final paidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    _buildTitle('تفاصيل المصروف'),
                    SizedBox(height: 20),
                    _buildNameField(),
                    SizedBox(height: 16),
                    _buildDateField(context),
                    SizedBox(height: 20),
                    _buildTitle('المبالغ'),
                    SizedBox(height: 20),
                    _buildTotalAmountField(),
                    SizedBox(height: 16),
                    _buildPaidAmountField(),
                    SizedBox(height: 30),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(Get.context!).padding.top + 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Text(
              'إضافة مصروف',
              style: ModernTheme.titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 40), // للموازنة
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return FadeInLeft(
      duration: Duration(milliseconds: 500),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return FadeInUp(
      duration: Duration(milliseconds: 600),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'اسم الصنف',
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.shopping_cart, color: Colors.green),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 700),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'التاريخ',
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              dateController.text = date.toString().split(' ')[0];
            }
          },
          validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
        ),
      ),
    );
  }

  Widget _buildTotalAmountField() {
    return FadeInUp(
      duration: Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: totalController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'السعر الكلي',
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.attach_money, color: Colors.green),
            suffixText: 'ج.م',
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'مطلوب';
            if (double.tryParse(value!) == null) return 'أدخل رقم صحيح';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPaidAmountField() {
    return FadeInUp(
      duration: Duration(milliseconds: 900),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: paidController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'المبلغ المدفوع',
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.payments, color: Colors.green),
            suffixText: 'ج.م',
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'مطلوب';
            if (double.tryParse(value!) == null) return 'أدخل رقم صحيح';
            if (totalController.text.isEmpty) return 'أدخل السعر الكلي أولاً';
            final paid = double.parse(value);
            final total = double.parse(totalController.text);
            if (paid > total) return 'المبلغ المدفوع أكبر من السعر الكلي';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return FadeInUp(
      duration: Duration(milliseconds: 1000),
      child: Container(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
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
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
          ),
          child: Text(
            'إضافة المصروف',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}