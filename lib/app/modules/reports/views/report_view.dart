import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/modern_theme.dart';
import '../../../data/models/cycle_report.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingView();
        }

        if (controller.reports.isEmpty) {
          return _buildEmptyView();
        }

        return _buildReportsList();
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Get.offAllNamed('/'),
      ),
      title: Text(
        'تقارير الدورات',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.green[600],
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل التقارير...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد تقارير',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.reports.length,
      itemBuilder: (context, index) {
        final report = controller.reports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(CycleReport report) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildReportHeader(report),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // إضافة معلومات الخزانة
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('مبلغ الخزانة الأساسي',
                          '${report.treasuryAmount} ج.م',
                          isBalance: true),
                      _buildSummaryRow('المتبقي في الخزانة',
                          '${report.treasuryAmount - report.totalPaid} ج.م',
                          isBalance: true,
                          isNegative:
                              (report.treasuryAmount - report.totalPaid) < 0),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // المعلومات الحالية
                _buildSummaryRow('عدد الكتاكيت', '${report.chicksCount}'),
                _buildSummaryRow(
                    'إجمالي المصروفات', '${report.totalExpenses} ج.م'),
                _buildSummaryRow('إجمالي المدفوع', '${report.totalPaid} ج.م'),
                _buildSummaryRow(
                    'إجمالي المتبقي', '${report.totalRemaining} ج.م',
                    isNegative: report.totalRemaining > 0),
              ],
            ),
          ),
          _buildExpensesDetails(report),
          _buildCardActions(report),
        ],
      ),
    );
  }

  Widget _buildReportHeader(CycleReport report) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.cycleName,
                  style: ModernTheme.subtitleStyle.copyWith(
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'من ${report.startDate.toString().split(' ')[0]} إلى ${report.expectedEndDate.toString().split(' ')[0]}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusChip(report),
        ],
      ),
    );
  }

  Widget _buildStatusChip(CycleReport report) {
    final now = DateTime.now();
    final isActive = now.isBefore(report.expectedEndDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'نشط' : 'منتهي',
        style: TextStyle(
          color: isActive ? Colors.green[800] : Colors.orange[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isNegative = false, bool isBalance = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isBalance
                  ? Colors.purple[700]
                  : isNegative
                      ? Colors.red
                      : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesDetails(CycleReport report) {
    return ExpansionTile(
      title: Text(
        'تفاصيل المصروفات',
        style: TextStyle(
          color: Colors.green[700],
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('الصنف')),
              DataColumn(label: Text('التاريخ')),
              DataColumn(label: Text('المبلغ الكلي')),
              DataColumn(label: Text('المدفوع')),
              DataColumn(label: Text('المتبقي')),
            ],
            rows: report.expenses.map((expense) {
              final remaining = expense.totalAmount - expense.paidAmount;
              return DataRow(cells: [
                DataCell(Text(expense.name)),
                DataCell(Text(expense.date.toString().split(' ')[0])),
                DataCell(Text('${expense.totalAmount} ج.م')),
                DataCell(Text('${expense.paidAmount} ج.م')),
                DataCell(Text(
                  '${remaining} ج.م',
                  style: TextStyle(
                    color: remaining > 0 ? Colors.red : Colors.green,
                  ),
                )),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

Widget _buildCardActions(CycleReport report) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
          onPressed: () => _showFinancialDataDialog(report),
          tooltip: 'تصدير PDF',
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteConfirmationDialog(report),
          tooltip: 'حذف الدورة',
        ),
      ],
    ),
  );
}

  

  void _showFinancialDataDialog(CycleReport report) {
  final totalRevenueController = TextEditingController();
  final totalWeightController = TextEditingController();

  Get.dialog(
    AlertDialog(
      title: Text('إدخال بيانات البيع'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: totalRevenueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'إجمالي المبيعات (ج.م)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: totalWeightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'إجمالي الوزن (كجم)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.scale),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            try {
              final totalRevenue = double.parse(totalRevenueController.text);
              final totalWeight = double.parse(totalWeightController.text);
              
              // إنشاء نسخة جديدة من التقرير مع البيانات المالية
              final updatedReport = report.copyWithFinancials(
                totalRevenue: totalRevenue,
                totalWeight: totalWeight,
              );
              
              Get.back(); // إغلاق مربع الحوار
              
              // إنشاء PDF مع البيانات المحدثة
              Get.find<ReportController>().generatePDF(updatedReport);
              
            } catch (e) {
              Get.snackbar(
                'خطأ',
                'يرجى إدخال أرقام صحيحة',
                backgroundColor: Colors.red[100],
                colorText: Colors.red[800],
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: Text('إنشاء التقرير'),
        ),
      ],
    ),
  );
}


  void _showDeleteConfirmationDialog(CycleReport report) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('تأكيد الحذف'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اختر طريقة حذف دورة ${report.cycleName}:'),
            SizedBox(height: 16),
            _buildDeleteOption(
              icon: Icons.phone_android,
              title: 'حذف من التطبيق فقط',
              subtitle:
                  'سيتم حذف البيانات من التطبيق مع الاحتفاظ بها على السيرفر',
              onTap: () {
                Get.back();
                controller.deleteCycle(report.cycleId, DeleteMode.localOnly);
              },
            ),
            SizedBox(height: 12),
            _buildDeleteOption(
              icon: Icons.cloud_off,
              title: 'حذف كامل',
              subtitle: 'سيتم حذف البيانات نهائياً من التطبيق والسيرفر',
              isDestructive: true,
              onTap: () {
                Get.back();
                controller.deleteCycle(report.cycleId, DeleteMode.complete);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('إلغاء'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDestructive ? Colors.red[100]! : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isDestructive ? Colors.red[50] : Colors.grey[50],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.grey[700],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDestructive ? Colors.red : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
}
