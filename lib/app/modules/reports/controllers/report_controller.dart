import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazra3ty_app/app/data/models/cycle_report.dart';
import 'package:mazra3ty_app/app/data/models/expense.dart';
import 'package:mazra3ty_app/app/modules/home/controllers/home_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportController extends GetxController {
  final homeController = Get.find<HomeController>();
  final reports = <CycleReport>[].obs;

  void deleteCycle(String cycleId) {
    // حذف الدورة من HomeController
    homeController.deleteCycle(cycleId);
    // حذف التقرير من القائمة المحلية
    reports.removeWhere((report) => report.cycleId == cycleId);
    
    Get.snackbar(
      'تم الحذف',
      'تم حذف الدورة بنجاح',
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
    );
  }

  @override
  void onInit() {
    super.onInit();
    createReports();
  }

  void createReports() {
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
  }

  Future<void> generatePDF(CycleReport report) async {
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
              pw.Text('عدد الكتاكيت: ${report.chicksCount}', style: pw.TextStyle(font: arabicFont)),
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
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('الصنف', style: pw.TextStyle(font: arabicBoldFont)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('التاريخ', style: pw.TextStyle(font: arabicBoldFont)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('المبلغ الكلي', style: pw.TextStyle(font: arabicBoldFont)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('المدفوع', style: pw.TextStyle(font: arabicBoldFont)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('المتبقي', style: pw.TextStyle(font: arabicBoldFont)),
                      ),
                    ],
                  ),
                  ...report.expenses.map((expense) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(expense.name, style: pw.TextStyle(font: arabicFont)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          expense.date.toString().split(' ')[0],
                          style: pw.TextStyle(font: arabicFont),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          '${expense.totalAmount} ج.م',
                          style: pw.TextStyle(font: arabicFont),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          '${expense.paidAmount} ج.م',
                          style: pw.TextStyle(font: arabicFont),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          '${expense.totalAmount - expense.paidAmount} ج.م',
                          style: pw.TextStyle(font: arabicFont),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'الملخص',
                style: pw.TextStyle(font: arabicBoldFont, fontSize: 18),
              ),
              pw.Text(
                'إجمالي المصروفات: ${report.totalExpenses} ج.م',
                style: pw.TextStyle(font: arabicFont),
              ),
              pw.Text(
                'إجمالي المدفوع: ${report.totalPaid} ج.م',
                style: pw.TextStyle(font: arabicFont),
              ),
              pw.Text(
                'إجمالي المتبقي: ${report.totalRemaining} ج.م',
                style: pw.TextStyle(font: arabicFont),
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'تقرير_${report.cycleName}.pdf',
    );
  }
}