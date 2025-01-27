// lib/app/modules/reports/controllers/report_controller.dart
import 'package:get/get.dart';
import 'package:mazra3ty_app/app/data/models/cycle_report.dart';
import 'package:mazra3ty_app/app/modules/home/controllers/home_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportController extends GetxController {
  final cycleReports = <CycleReport>[].obs;
  
  void generateReport(String cycleId) async {
    final homeController = Get.find<HomeController>();
    final cycle = homeController.cycles.firstWhere((c) => c.id == cycleId);
    
    final report = CycleReport(
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
    );

    cycleReports.add(report);
    _generatePDF(report);
  }

  Future<void> _generatePDF(CycleReport report) async {
    final pdf = pw.Document();
    
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        children: [
          pw.Header(level: 0, child: pw.Text('تقرير دورة: ${report.cycleName}')),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['الصنف', 'التاريخ', 'المبلغ الكلي', 'المدفوع', 'المتبقي'],
            data: report.expenses.map((e) => [
              e.name,
              e.date.toString().split(' ')[0],
              e.totalAmount.toString(),
              e.paidAmount.toString(),
              (e.totalAmount - e.paidAmount).toString(),
            ]).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text('إجمالي المصروفات: ${report.totalExpenses}'),
          pw.Text('إجمالي المدفوع: ${report.totalPaid}'),
          pw.Text('إجمالي المتبقي: ${report.totalRemaining}'),
        ],
      ),
    ));

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'تقرير_${report.cycleName}.pdf');
  }
}
