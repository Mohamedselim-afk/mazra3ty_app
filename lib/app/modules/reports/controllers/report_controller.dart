// lib/app/modules/reports/controllers/report_controller.dart
import 'package:get/get.dart';
import 'package:mazra3ty_app/app/data/models/cycle_report.dart';
import 'package:mazra3ty_app/app/data/models/expense.dart';
import 'package:mazra3ty_app/app/modules/home/controllers/home_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportController extends GetxController {
  final homeController = Get.find<HomeController>();
  final cycleReport = Rxn<CycleReport>();
  final report = Rxn<CycleReport>();

  @override
  void onInit() {
    super.onInit();
    final cycleId = Get.parameters['cycleId'];
    if (cycleId != null) createReport(cycleId);
  }

  void createReport(String cycleId) {
    final cycle = homeController.cycles.firstWhere((c) => c.id == cycleId);

    report.value = CycleReport(
      cycleId: cycle.id,
      cycleName: cycle.name,
      startDate: cycle.startDate,
      expectedEndDate: cycle.expectedSaleDate,
      chicksCount: cycle.chicksCount,
      expenses:
          cycle.expenses
              .map(
                (e) => ExpenseReport(
                  name: e.name,
                  date: e.date,
                  totalAmount: e.totalAmount,
                  paidAmount: e.paidAmount,
                ),
              )
              .toList(),
    );
  }

  void generatePDF() async {
    if (cycleReport.value == null) return;

    final report = cycleReport.value!;
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => pw.Column(
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('تقرير دورة: ${report.cycleName}'),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: [
                    'الصنف',
                    'التاريخ',
                    'المبلغ الكلي',
                    'المدفوع',
                    'المتبقي',
                  ],
                  data:
                      report.expenses
                          .map(
                            (e) => [
                              e.name,
                              e.date.toString().split(' ')[0],
                              e.totalAmount.toString(),
                              e.paidAmount.toString(),
                              (e.totalAmount - e.paidAmount).toString(),
                            ],
                          )
                          .toList(),
                ),
                pw.SizedBox(height: 20),
                pw.Text('إجمالي المصروفات: ${report.totalExpenses}'),
                pw.Text('إجمالي المدفوع: ${report.totalPaid}'),
                pw.Text('إجمالي المتبقي: ${report.totalRemaining}'),
              ],
            ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'تقرير_${report.cycleName}.pdf',
    );
  }
}
