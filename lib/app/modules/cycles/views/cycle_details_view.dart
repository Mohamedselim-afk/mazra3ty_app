import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/theme/modern_theme.dart';
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
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(() {
      final total = controller.expenses.fold<double>(
        0,
        (sum, expense) => sum + expense.totalAmount,
      );
      final paid = controller.expenses.fold<double>(
        0,
        (sum, expense) => sum + expense.paidAmount,
      );
      final remaining = total - paid;

      return Container(
        height: 170,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          children: [
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
  }) {
    return FadeInRight(
      delay: Duration(milliseconds: delay),
      child: Container(
        width: 200,
        height: 120, // تحديد ارتفاع ثابت
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
                      data: Theme.of(
                        Get.context!,
                      ).copyWith(dividerColor: Colors.transparent),
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
                        children:
                            expenses.map((expense) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
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
        onPressed:
            () => Get.toNamed('/add-expense/${controller.cycleId.value}'),
        backgroundColor: Colors.green[700],
        icon: Icon(Icons.add_circle_outline),
        label: Text('إضافة مصروف'),
      ),
    );
  }
}
