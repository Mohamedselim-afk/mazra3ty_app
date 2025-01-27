// lib/app/modules/reports/views/report_view.dart
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
          onPressed: () => Get.offNamed('/expense/${Get.parameters['cycleId']}'),
        ),
        title: Text('تقرير الدورة'),
        backgroundColor: Colors.green[600],
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => controller.generatePDF(),
          ),
        ],
      ),
      body: Obx(() {
        final report = controller.cycleReport.value;
        
        if (report == null) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(report),
              SizedBox(height: 16),
              _buildExpensesTable(report),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(CycleReport report) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اسم الدورة: ${report.cycleName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('عدد الكتاكيت: ${report.chicksCount}'),
            Text('تاريخ البداية: ${report.startDate.toString().split(' ')[0]}'),
            Text('تاريخ البيع المتوقع: ${report.expectedEndDate.toString().split(' ')[0]}'),
            Divider(),
            Text('إجمالي المصروفات: ${report.totalExpenses} ج.م'),
            Text('إجمالي المدفوع: ${report.totalPaid} ج.م'),
            Text('إجمالي المتبقي: ${report.totalRemaining} ج.م',
                style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesTable(CycleReport report) {
    return SingleChildScrollView(
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
    );
  }
}