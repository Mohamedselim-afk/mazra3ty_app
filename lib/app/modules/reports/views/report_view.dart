import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cycle_report.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/'),
        ),
        title: Text('تقارير الدورات'),
        backgroundColor: Colors.green[600],
      ),
      body: Obx(() {
        if (controller.reports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد تقارير',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.reports.length,
          itemBuilder: (context, index) {
            final report = controller.reports[index];
            return _buildReportCard(report);
          },
        );
      }),
    );
  }

  Widget _buildReportCard(CycleReport report) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              report.cycleName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'من ${report.startDate.toString().split(' ')[0]} إلى ${report.expectedEndDate.toString().split(' ')[0]}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
                  onPressed: () => controller.generatePDF(report),
                  tooltip: 'تصدير PDF',
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => Get.dialog(
                    AlertDialog(
                      title: Text('تأكيد الحذف'),
                      content: Text('هل أنت متأكد من حذف دورة ${report.cycleName}؟'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('إلغاء'),
                          onPressed: () => Get.back(),
                        ),
                        TextButton(
                          child: Text(
                            'حذف',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Get.back();
                            controller.deleteCycle(report.cycleId);
                          },
                        ),
                      ],
                    ),
                  ),
                  tooltip: 'حذف الدورة',
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow('عدد الكتاكيت', '${report.chicksCount}'),
                _buildSummaryRow('إجمالي المصروفات', '${report.totalExpenses} ج.م'),
                _buildSummaryRow('إجمالي المدفوع', '${report.totalPaid} ج.م'),
                _buildSummaryRow('إجمالي المتبقي', '${report.totalRemaining} ج.م'),
              ],
            ),
          ),
          ExpansionTile(
            title: Text('تفاصيل المصروفات'),
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
                    return DataRow(cells: [
                      DataCell(Text(expense.name)),
                      DataCell(Text(expense.date.toString().split(' ')[0])),
                      DataCell(Text('${expense.totalAmount} ج.م')),
                      DataCell(Text('${expense.paidAmount} ج.م')),
                      DataCell(Text('${expense.totalAmount - expense.paidAmount} ج.م')),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: label.contains('المتبقي') ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}