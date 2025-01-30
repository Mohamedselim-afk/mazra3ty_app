import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../data/models/cycle_report.dart';
import '../../../data/models/expense.dart';
import '../../home/controllers/home_controller.dart';

class ReportController extends GetxController {
  final homeController = Get.find<HomeController>();
  final reports = <CycleReport>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    createReports();
  }

  void createReports() {
    try {
      isLoading.value = true;
      final cycles = homeController.cycles;
      reports.assignAll(cycles.map((cycle) => CycleReport(
        cycleId: cycle.id,
        cycleName: cycle.name,
        startDate: cycle.startDate,
        expectedEndDate: cycle.expectedSaleDate,
        chicksCount: cycle.chicksCount,
        expenses: cycle.expenses.map((e) => ExpenseReport(
          name: e.name,
          date: e.date,
          totalAmount: e.totalAmount,
          paidAmount: e.paidAmount,
        )).toList(),
      )));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCycle(String cycleId, DeleteMode mode) async {
    try {
      switch (mode) {
        case DeleteMode.localOnly:
          await homeController.deleteLocalCycle(cycleId);
          break;
        case DeleteMode.complete:
          await homeController.deleteFullCycle(cycleId);
          break;
      }
      
      // Remove from reports list
      reports.removeWhere((report) => report.cycleId == cycleId);
      
      Get.back(); // Close dialog
      
    } catch (e) {
      print('Error deleting cycle: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف الدورة',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> generatePDF(CycleReport report) async {
    try {
      final pdf = pw.Document();
      final arabicFont = await PdfGoogleFonts.cairoRegular();
      final arabicBoldFont = await PdfGoogleFonts.cairoBold();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'تقرير دورة: ${report.cycleName}',
                    style: pw.TextStyle(
                      font: arabicBoldFont,
                      fontSize: 24,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'معلومات الدورة',
                  style: pw.TextStyle(font: arabicBoldFont, fontSize: 18),
                ),
                pw.Text('عدد الكتاكيت: ${report.chicksCount}', 
                  style: pw.TextStyle(font: arabicFont)),
                pw.Text(
                  'تاريخ البداية: ${report.startDate.toString().split(' ')[0]}',
                  style: pw.TextStyle(font: arabicFont),
                ),
                pw.Text(
                  'تاريخ البيع المتوقع: ${report.expectedEndDate.toString().split(' ')[0]}',
                  style: pw.TextStyle(font: arabicFont),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'المصروفات',
                  style: pw.TextStyle(font: arabicBoldFont, fontSize: 18),
                ),
                _buildExpensesTable(report, arabicFont, arabicBoldFont),
                pw.SizedBox(height: 20),
                _buildSummary(report, arabicFont, arabicBoldFont),
              ],
            ),
          ),
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'تقرير_${report.cycleName}.pdf',
      );
    } catch (e) {
      print('Error generating PDF: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إنشاء التقرير',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  pw.Widget _buildExpensesTable(CycleReport report, pw.Font font, pw.Font boldFont) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            _buildHeaderCell('الصنف', boldFont),
            _buildHeaderCell('التاريخ', boldFont),
            _buildHeaderCell('المبلغ الكلي', boldFont),
            _buildHeaderCell('المدفوع', boldFont),
            _buildHeaderCell('المتبقي', boldFont),
          ],
        ),
        ...report.expenses.map((expense) => pw.TableRow(
          children: [
            _buildCell(expense.name, font),
            _buildCell(expense.date.toString().split(' ')[0], font),
            _buildCell('${expense.totalAmount} ج.م', font),
            _buildCell('${expense.paidAmount} ج.م', font),
            _buildCell('${expense.totalAmount - expense.paidAmount} ج.م', font),
          ],
        )),
      ],
    );
  }

  pw.Widget _buildHeaderCell(String text, pw.Font font) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(5),
      child: pw.Text(text, style: pw.TextStyle(font: font)),
    );
  }

  pw.Widget _buildCell(String text, pw.Font font) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(5),
      child: pw.Text(text, style: pw.TextStyle(font: font)),
    );
  }

  pw.Widget _buildSummary(CycleReport report, pw.Font font, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'الملخص',
          style: pw.TextStyle(font: boldFont, fontSize: 18),
        ),
        pw.Text(
          'إجمالي المصروفات: ${report.totalExpenses} ج.م',
          style: pw.TextStyle(font: font),
        ),
        pw.Text(
          'إجمالي المدفوع: ${report.totalPaid} ج.م',
          style: pw.TextStyle(font: font),
        ),
        pw.Text(
          'إجمالي المتبقي: ${report.totalRemaining} ج.م',
          style: pw.TextStyle(font: font),
        ),
      ],
    );
  }
}

enum DeleteMode {
  localOnly,
  complete,
}