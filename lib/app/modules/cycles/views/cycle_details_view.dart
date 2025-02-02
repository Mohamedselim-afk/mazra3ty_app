import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/theme/modern_theme.dart';
import '../../../data/models/expense.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/expense_controller.dart';

class CycleDetailsView extends GetView<ExpenseController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Column(
              children: [
                _buildSummaryCards(),
                Expanded(child: _buildExpensesList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAddExpenseButton(),
    );
  }

  Widget _buildHeader() {
  return FadeInDown(
    duration: Duration(milliseconds: 500),
    child: Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(Get.context!).padding.top + 50,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        gradient: ModernTheme.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: Text(
                  'تفاصيل الدورة',
                  style: ModernTheme.titleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) => _handleMenuSelection(value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.blue),
                      title: Text('تعديل الدورة'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// إضافة دالة معالجة اختيارات القائمة
void _handleMenuSelection(String value) {
  switch (value) {
    case 'edit':
      _showEditCycleDialog();
      break;
  }
}

// إضافة دالة عرض نافذة التعديل
void _showEditCycleDialog() {
  final homeController = Get.find<HomeController>();
  final cycle = homeController.cycles.firstWhere((c) => c.id == controller.cycleId.value);

  final nameController = TextEditingController(text: cycle.name);
  final chicksCountController = TextEditingController(text: cycle.chicksCount.toString());
  final treasuryController = TextEditingController(text: cycle.treasuryAmount.toString());
  final startDateController = TextEditingController(text: cycle.startDate.toString().split(' ')[0]);
  final endDateController = TextEditingController(text: cycle.expectedSaleDate.toString().split(' ')[0]);

  DateTime selectedStartDate = cycle.startDate;
  DateTime selectedEndDate = cycle.expectedSaleDate;

  Get.dialog(
    AlertDialog(
      title: Text('تعديل الدورة'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // حقل اسم الدورة
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'اسم الدورة',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            SizedBox(height: 16),

            // حقل عدد الكتاكيت
            TextField(
              controller: chicksCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'عدد الكتاكيت',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            SizedBox(height: 16),

            // حقل مبلغ الخزانة
            TextField(
              controller: treasuryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'مبلغ الخزانة',
                prefixIcon: Icon(Icons.account_balance_wallet),
                suffixText: 'ج.م',
              ),
            ),
            SizedBox(height: 16),

            // حقل تاريخ البداية
            TextField(
              controller: startDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'تاريخ البداية',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: selectedStartDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  selectedStartDate = date;
                  startDateController.text = date.toString().split(' ')[0];
                }
              },
            ),
            SizedBox(height: 16),

            // حقل تاريخ البيع المتوقع
            TextField(
              controller: endDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'تاريخ البيع المتوقع',
                prefixIcon: Icon(Icons.event),
              ),
              onTap: () async {
                if (startDateController.text.isEmpty) {
                  Get.snackbar(
                    'تنبيه',
                    'يرجى اختيار تاريخ البداية أولاً',
                    backgroundColor: Colors.orange[100],
                    colorText: Colors.orange[800],
                  );
                  return;
                }

                final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: selectedEndDate,
                  firstDate: selectedStartDate,
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  selectedEndDate = date;
                  endDateController.text = date.toString().split(' ')[0];
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('إلغاء'),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          child: Text('حفظ التعديلات'),
          onPressed: () {
            try {
              final updatedCycle = cycle.copyWith(
                name: nameController.text,
                chicksCount: int.parse(chicksCountController.text),
                treasuryAmount: double.parse(treasuryController.text),
                startDate: selectedStartDate,
                expectedSaleDate: selectedEndDate,
              );

              homeController.updateCycle(updatedCycle);
              Get.back();
              
              Get.snackbar(
                'تم بنجاح',
                'تم تحديث بيانات الدورة',
                backgroundColor: Colors.green[100],
                colorText: Colors.green[800],
              );
            } catch (e) {
              Get.snackbar(
                'خطأ',
                'يرجى التأكد من صحة البيانات المدخلة',
                backgroundColor: Colors.red[100],
                colorText: Colors.red[800],
              );
            }
          },
        ),
      ],
    ),
  );
}

  Widget _buildSummaryCards() {
  return Obx(() {
    final cycle = Get.find<HomeController>().cycles
        .firstWhere((c) => c.id == controller.cycleId.value);
    
    final total = controller.expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.totalAmount,
    );
    final paid = controller.expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.paidAmount,
    );
    final remaining = total - paid;
    final treasuryRemaining = cycle.treasuryAmount - paid;

    return Container(
      height: 170,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          // كارت الخزانة
          _buildSummaryCard(
            'رصيد الخزانة',
            '${cycle.treasuryAmount} ج.م',
            Icons.account_balance_wallet,
            Colors.purple,
            delay: 50,
            subtitle: 'المتبقي: $treasuryRemaining ج.م',
          ),
          
          _buildSummaryCard(
            'إجمالي المصروفات',
            '$total ج.م',
            Icons.account_balance_wallet,
            Colors.blue,
            delay: 100,
          ),
          
          _buildSummaryCard(
            'إجمالي المدفوع',
            '$paid ج.م',
            Icons.paid,
            Colors.green,
            delay: 200,
          ),
          
          _buildSummaryCard(
            'إجمالي المتبقي',
            '$remaining ج.م',
            Icons.pending,
            Colors.orange,
            delay: 300,
          ),
        ],
      ),
    );
  });
}


  Widget _buildSummaryCard(
  String title,
  String amount,
  IconData icon,
  MaterialColor color, {
  int delay = 0,
  String? subtitle,
}) {
  return FadeInRight(
    delay: Duration(milliseconds: delay),
    child: Container(
      width: 200,
      height: 120,
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color[300]!, color[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  amount,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildExpensesList() {
    return Obx(() {
      if (controller.expenses.isEmpty) {
        return _buildEmptyState();
      }

      final groupedExpenses = <String, List<dynamic>>{};
      for (var expense in controller.expenses) {
        if (!groupedExpenses.containsKey(expense.name)) {
          groupedExpenses[expense.name] = [];
        }
        groupedExpenses[expense.name]!.add(expense);
      }

      return AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.all(20),
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

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: ModernTheme.modernCardDecoration,
                    child: Theme(
                      data: Theme.of(Get.context!)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.all(16),
                        childrenPadding: EdgeInsets.all(16),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.shopping_bag, color: Colors.green),
                        ),
                        title: Text(name, style: ModernTheme.subtitleStyle),
                        subtitle: Text(
                          'المتبقي: $remainingAmount ج.م',
                          style: TextStyle(color: Colors.red),
                        ),
                        children: expenses.map((expense) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      expense.date.toString().split(' ')[0],
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'الكلي: ${expense.totalAmount} ج.م',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          'المدفوع: ${expense.paidAmount} ج.م',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () =>
                                          _showEditExpenseDialog(expense),
                                      tooltip: 'تعديل',
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () =>
                                          _showDeleteConfirmation(expense),
                                      tooltip: 'حذف',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

// في دالة _showEditExpenseDialog
  void _showEditExpenseDialog(Expense expense) {
    final nameController = TextEditingController(text: expense.name);
    final totalController =
        TextEditingController(text: expense.totalAmount.toString());
    final paidController =
        TextEditingController(text: expense.paidAmount.toString());
    final dateController = TextEditingController(
      text: expense.date.toString().split(' ')[0],
    );

    DateTime selectedDate = expense.date;

    Get.dialog(
      AlertDialog(
        title: Text('تعديل المصروف'),
        content: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // حقل الاسم
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المصروف',
                    prefixIcon: Icon(Icons.shopping_bag_outlined),
                  ),
                ),
                SizedBox(height: 16),

                // حقل المبلغ الكلي
                TextField(
                  controller: totalController,
                  decoration: InputDecoration(
                    labelText: 'المبلغ الكلي',
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // حقل المبلغ المدفوع
                TextField(
                  controller: paidController,
                  decoration: InputDecoration(
                    labelText: 'المبلغ المدفوع',
                    prefixIcon: Icon(Icons.payment_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // حقل التاريخ
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'التاريخ',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      selectedDate = picked;
                      dateController.text = picked.toString().split(' ')[0];
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('إلغاء'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: Text('حفظ'),
            onPressed: () {
              // التحقق من صحة القيم المدخلة
              try {
                final newTotal = double.parse(totalController.text);
                final newPaid = double.parse(paidController.text);

                if (nameController.text.isEmpty) {
                  Get.snackbar(
                    'خطأ',
                    'يرجى إدخال اسم المصروف',
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[800],
                  );
                  return;
                }

                if (newPaid > newTotal) {
                  Get.snackbar(
                    'خطأ',
                    'المبلغ المدفوع لا يمكن أن يكون أكبر من المبلغ الكلي',
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[800],
                  );
                  return;
                }

                controller.updateExpense(
                  expense,
                  newName: nameController.text,
                  newTotalAmount: newTotal,
                  newPaidAmount: newPaid,
                  newDate: selectedDate,
                );
              } catch (e) {
                Get.snackbar(
                  'خطأ',
                  'يرجى التأكد من صحة القيم المدخلة',
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[800],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(dynamic expense) {
    Get.dialog(
      AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف هذا المصروف؟'),
        actions: [
          TextButton(
            child: Text('إلغاء'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('حذف'),
            onPressed: () {
              // Call controller method to delete expense
              controller.deleteExpense(expense);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: FadeInUp(
        duration: Duration(milliseconds: 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 100,
              color: Colors.green[300],
            ),
            SizedBox(height: 24),
            Text('لا توجد مصروفات', style: ModernTheme.subtitleStyle),
            SizedBox(height: 8),
            Text(
              'أضف مصروفات جديدة',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddExpenseButton() {
    return Pulse(
      // infinite: true,
      duration: Duration(seconds: 2),
      child: FloatingActionButton.extended(
        onPressed: () =>
            Get.toNamed('/add-expense/${controller.cycleId.value}'),
        backgroundColor: Colors.green[700],
        icon: Icon(Icons.add_circle_outline),
        label: Text('إضافة مصروف'),
      ),
    );
  }
}
