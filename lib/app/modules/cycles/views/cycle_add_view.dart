import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cycle.dart';
import '../controllers/cycle_controller.dart';

class AddCycleView extends GetView<CycleController> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
    final chicksCountController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة دورة جديدة'),
        backgroundColor: Colors.green[600],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'اسم الدورة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'يرجى إدخال اسم الدورة' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: chicksCountController,
              decoration: InputDecoration(
                labelText: 'عدد الكتاكيت',
                prefixIcon: Icon(Icons.pets),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'مطلوب';
                if (int.tryParse(value!) == null) return 'أدخل رقم صحيح';
                return null;
              },
            ),

            SizedBox(height: 16),
            TextFormField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'تاريخ البدء',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  startDateController.text = date.toString().split(' ')[0];
                }
              },
              validator: (value) =>
                  value?.isEmpty ?? true ? 'يرجى اختيار تاريخ البدء' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: endDateController,
              decoration: InputDecoration(
                labelText: 'تاريخ البيع المتوقع',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.event),
              ),
              readOnly: true,
              onTap: () async {
                if (startDateController.text.isEmpty) {
                  Get.snackbar(
                    'تنبيه',
                    'يرجى اختيار تاريخ البدء أولاً',
                    backgroundColor: Colors.orange[100],
                    colorText: Colors.orange[800],
                  );
                  return;
                }
                
                final startDate = DateTime.parse(startDateController.text);
                final date = await showDatePicker(
                  context: context,
                  initialDate: startDate.add(Duration(days: 45)),
                  firstDate: startDate,
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  endDateController.text = date.toString().split(' ')[0];
                }
              },
              validator: (value) =>
                  value?.isEmpty ?? true ? 'يرجى اختيار تاريخ البيع المتوقع' : null,
            ),
            SizedBox(height: 24),
                        ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newCycle = Cycle(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    startDate: DateTime.parse(startDateController.text),
                    expectedSaleDate: DateTime.parse(endDateController.text),
                    chicksCount: int.parse(chicksCountController.text),
                    expenses: [],
                  );
                  controller.addNewCycle(newCycle);
                  Get.back();
                }
              },
              child: Text('إنشاء الدورة'),
            ),
          ],

        ),
      ),
    );
  }
}
