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
  final totalRevenueController = TextEditingController();
  final totalWeightController = TextEditingController();
  final selectedReportId = RxString('');


  @override
  void onInit() {
    super.onInit();
    createReports();
  }

  @override
  void onClose() {
    totalRevenueController.dispose();
    totalWeightController.dispose();
    super.onClose();
  }

  


  // إنشاء التقارير من البيانات المتوفرة
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
            treasuryAmount: cycle.treasuryAmount,
            expenses: cycle.expenses
                .map((e) => ExpenseReport(
                      name: e.name,
                      date: e.date,
                      totalAmount: e.totalAmount,
                      paidAmount: e.paidAmount,
                    ))
                .toList(),
          )));
    } finally {
      isLoading.value = false;
    }
  }


    void updateFinancialData(String reportId) {
    try {
      final revenue = double.parse(totalRevenueController.text);
      final weight = double.parse(totalWeightController.text);
      
      final index = reports.indexWhere((report) => report.cycleId == reportId);
      if (index != -1) {
        final updatedReport = reports[index].copyWithFinancials(
          totalRevenue: revenue,
          totalWeight: weight,
        );
        reports[index] = updatedReport;
        
        Get.snackbar(
          'تم بنجاح',
          'تم تحديث البيانات المالية',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'يرجى التأكد من إدخال أرقام صحيحة',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }


  // حذف دورة
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

      reports.removeWhere((report) => report.cycleId == cycleId);
      Get.back();
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

    // تحديث دالة إنشاء PDF لإضافة قسم الملخص المالي
  Future<void> generatePDF(CycleReport report) async {
    try {
      final pdf = pw.Document();
      final arabicFont = await PdfGoogleFonts.cairoRegular();
      final arabicBoldFont = await PdfGoogleFonts.cairoBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(20),
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicBoldFont,
          ),
          build: (context) => [
            _buildReportHeader(report, arabicBoldFont),
            pw.SizedBox(height: 20),
            _buildBoxedSection(
              title: 'معلومات الدورة الأساسية',
              content: _buildCycleInfo(report, arabicFont),
              boldFont: arabicBoldFont,
            ),
            pw.SizedBox(height: 15),
            _buildBoxedSection(
              title: 'بيانات الخزانة',
              content: _buildTreasuryInfo(report, arabicFont),
              boldFont: arabicBoldFont,
            ),
            pw.SizedBox(height: 15),
            _buildBoxedSection(
              title: 'تفاصيل المصروفات',
              content: _buildExpensesTable(report, arabicFont, arabicBoldFont),
              boldFont: arabicBoldFont,
            ),
            pw.SizedBox(height: 15),
            _buildBoxedSection(
              title: 'الملخص المالي النهائي',
              content: _buildFinancialSummary(report, arabicFont),
              boldFont: arabicBoldFont,
            ),
          ],
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




  pw.Widget _buildFinancialSummary(CycleReport report, pw.Font font) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: pw.EdgeInsets.all(12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // قسم المبيعات
          _buildSectionTitle('بيانات المبيعات', font),
          pw.SizedBox(height: 8),
          _buildInfoRow('إجمالي المبيعات:', _formatCurrency(report.totalRevenue), font, valueColor: PdfColors.green700),
          _buildInfoRow('إجمالي الوزن:', '${report.totalWeight.toStringAsFixed(2)} كجم', font),
          _buildInfoRow('سعر الكيلو:', _formatCurrency(report.pricePerKilo), font),
          _buildInfoRow('متوسط وزن الكتكوت:', '${report.averageChickWeight.toStringAsFixed(2)} كجم', font),
          pw.SizedBox(height: 12),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 12),

          // قسم المصروفات والأرباح
          _buildSectionTitle('الحسابات النهائية', font),
          pw.SizedBox(height: 8),
          _buildInfoRow('إجمالي المصروفات:', _formatCurrency(report.totalExpenses), font, valueColor: PdfColors.red700),
          _buildInfoRow('المدفوع:', _formatCurrency(report.totalPaid), font),
          _buildInfoRow('المتبقي من المصروفات:', _formatCurrency(report.totalRemaining), font,
              valueColor: report.totalRemaining > 0 ? PdfColors.red700 : PdfColors.green700),
          pw.SizedBox(height: 12),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 12),

          // الملخص النهائي
          _buildSectionTitle('الملخص النهائي', font),
          pw.SizedBox(height: 8),
          _buildInfoRow('صافي الربح:', _formatCurrency(report.netProfit), font,
              valueColor: report.netProfit >= 0 ? PdfColors.green700 : PdfColors.red700),
          _buildInfoRow('المتبقي في الخزانة:', _formatCurrency(report.remainingTreasury), font,
              valueColor: report.remainingTreasury >= 0 ? PdfColors.green700 : PdfColors.red700),
        ],
      ),
    );
  }

  pw.Widget _buildSectionTitle(String title, pw.Font font) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        font: font,
        color: PdfColors.green900,
        fontSize: 14,
      ),
    );
  }

  String _formatCurrencyValue(double amount) {
    return '${amount.toStringAsFixed(2)} ج.م';
  }



// تحسين شكل رأس التقرير
  pw.Widget _buildReportHeader(CycleReport report, pw.Font boldFont) {
    return pw.Container(
      padding: pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.green800, width: 1),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'تقرير دورة: ${report.cycleName}',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 20,
              color: PdfColors.green900,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'تاريخ التقرير: ${_formatDate(DateTime.now())}',
            style: pw.TextStyle(font: boldFont, fontSize: 14),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

// إطار موحد للأقسام
  pw.Widget _buildBoxedSection({
    required String title,
    required pw.Widget content,
    required pw.Font boldFont,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Container(
            padding: pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.green100,
              borderRadius:
                  pw.BorderRadius.vertical(top: pw.Radius.circular(8)),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                font: boldFont,
                color: PdfColors.green900,
                fontSize: 16,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Container(
            padding: pw.EdgeInsets.all(10),
            child: content,
          ),
        ],
      ),
    );
  }

// تحسين عرض معلومات الدورة
  pw.Widget _buildCycleInfo(CycleReport report, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildInfoRow('عدد الكتاكيت:', '${report.chicksCount}', font),
        _buildInfoRow('تاريخ البداية:', _formatDate(report.startDate), font),
        _buildInfoRow(
            'تاريخ البيع المتوقع:', _formatDate(report.expectedEndDate), font),
      ],
    );
  }

// تحسين عرض معلومات الخزانة
  pw.Widget _buildTreasuryInfo(CycleReport report, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildInfoRow('المبلغ الأساسي في الخزانة:',
            '${_formatCurrency(report.treasuryAmount)}', font),
        _buildInfoRow('إجمالي المصروفات المدفوعة:',
            '${_formatCurrency(report.totalPaid)}', font),
        _buildInfoRow(
          'المتبقي في الخزانة:',
          _formatCurrency(report.treasuryAmount - report.totalPaid),
          font,
          valueColor: (report.treasuryAmount - report.totalPaid) < 0
              ? PdfColors.red
              : PdfColors.green,
        ),
      ],
    );
  }

// تحسين جدول المصروفات
  pw.Widget _buildExpensesTable(
      CycleReport report, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey400),
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
        tableWidth: pw.TableWidth.max,
        columnWidths: {
        0: pw.FlexColumnWidth(2.5), // المتبقي
        1: pw.FlexColumnWidth(2.5), // المدفوع
        2: pw.FlexColumnWidth(2.5), // المبلغ الكلي
        3: pw.FlexColumnWidth(2.5), // التاريخ
        4: pw.FlexColumnWidth(2.5), // الصنف
        },
        children: [
          // رأس الجدول
          pw.TableRow(
            decoration: pw.BoxDecoration(
              color: PdfColors.green100,
            ),
            children: [
            _buildHeaderCell('المتبقي', boldFont),
            _buildHeaderCell('المدفوع', boldFont),
            _buildHeaderCell('المبلغ الكلي', boldFont),
            _buildHeaderCell('التاريخ', boldFont),
            _buildHeaderCell('الصنف', boldFont),
            ],
          ),
          // صفوف البيانات
          ...report.expenses.map((expense) {
            final remaining = expense.totalAmount - expense.paidAmount;
            return pw.TableRow(
              children: [
              _buildDataCell(
                _formatCurrency(remaining), 
                font,
                textColor: remaining > 0 ? PdfColors.red : PdfColors.green,
              ), // المتبقي
              _buildDataCell(_formatCurrency(expense.paidAmount), font), // المدفوع
              _buildDataCell(_formatCurrency(expense.totalAmount), font), // المبلغ الكلي
              _buildDataCell(_formatDate(expense.date), font), // التاريخ
              _buildDataCell(expense.name, font), // الصنف
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

// خلية عنوان في الجدول
pw.Widget _buildHeaderCell(String text, pw.Font font) {
  return pw.Container(
    padding: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    alignment: pw.Alignment.center,
    child: pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        color: PdfColors.green900,
      ),
      textAlign: pw.TextAlign.center,
    ),
  );
}

// خلية بيانات في الجدول
pw.Widget _buildDataCell(String text, pw.Font font, {PdfColor? textColor}) {
  return pw.Container(
    padding: pw.EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    alignment: pw.Alignment.center,
    child: pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        color: textColor,
      ),
      textAlign: pw.TextAlign.center,
    ),
  );
}

// صف عناوين الجدول
  pw.TableRow _buildTableHeader(pw.Font boldFont) {
    final headers = ['الصنف', 'التاريخ', 'المبلغ الكلي', 'المدفوع', 'المتبقي'];
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: PdfColors.grey200),
      children: headers
          .map((text) => pw.Container(
                alignment: pw.Alignment.center,
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  text,
                  style: pw.TextStyle(font: boldFont),
                  textAlign: pw.TextAlign.center,
                ),
              ))
          .toList(),
    );
  }

// صف بيانات المصروفات
  pw.TableRow _buildExpenseRow(ExpenseReport expense, pw.Font font) {
    final remaining = expense.totalAmount - expense.paidAmount;
    return pw.TableRow(
      children: [
        _buildTableCell(expense.name, font),
        _buildTableCell(_formatDate(expense.date), font),
        _buildTableCell(_formatCurrency(expense.totalAmount), font),
        _buildTableCell(_formatCurrency(expense.paidAmount), font),
        _buildTableCell(
          _formatCurrency(remaining),
          font,
          textColor: remaining > 0 ? PdfColors.red : PdfColors.green,
        ),
      ],
    );
  }

// خلية في الجدول
  pw.Widget _buildTableCell(String text, pw.Font font, {PdfColor? textColor}) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          color: textColor,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

// تحسين عرض الملخص النهائي
  pw.Widget _buildFinalSummary(CycleReport report, pw.Font font) {
    final treasuryRemaining = report.treasuryAmount - report.totalPaid;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
            'إجمالي المصروفات:', _formatCurrency(report.totalExpenses), font),
        _buildInfoRow(
            'إجمالي المدفوع:', _formatCurrency(report.totalPaid), font),
        _buildInfoRow(
          'إجمالي المتبقي من المصروفات:',
          _formatCurrency(report.totalRemaining),
          font,
          valueColor:
              report.totalRemaining > 0 ? PdfColors.red : PdfColors.green,
        ),
        _buildInfoRow(
          'المتبقي في الخزانة:',
          _formatCurrency(treasuryRemaining),
          font,
          valueColor: treasuryRemaining < 0 ? PdfColors.red : PdfColors.green,
        ),
      ],
    );
  }

// صف معلومات عام
  pw.Widget _buildInfoRow(String label, String value, pw.Font font,
      {PdfColor? valueColor}) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(font: font)),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: font,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

// تنسيق التاريخ
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

// تنسيق المبالغ المالية
  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} ج.م';
  }
}

// تعريف أنواع الحذف
enum DeleteMode {
  localOnly, // حذف محلي فقط
  complete, // حذف كامل
}

