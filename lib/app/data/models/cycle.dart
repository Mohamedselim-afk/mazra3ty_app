import 'package:mazra3ty_app/app/data/models/expense.dart';

class Cycle {
  String id;
  String name;
  DateTime startDate;
  DateTime expectedSaleDate;
  int chicksCount;
  List<Expense> expenses;

  Cycle({
    required this.id,
    required this.name,
    required this.startDate,
    required this.expectedSaleDate,
    required this.chicksCount,
    required this.expenses,
  });
}
