import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../data/models/cycle.dart';
import '../controllers/cycle_controller.dart';
import '../../../core/theme/modern_theme.dart';

class AddCycleView extends GetView<CycleController> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final chicksCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    _buildTitle('معلومات الدورة'),
                    SizedBox(height: 20),
                    _buildNameField(),
                    SizedBox(height: 16),
                    _buildChicksCountField(),
                    SizedBox(height: 20),
                    _buildTitle('تواريخ الدورة'),
                    SizedBox(height: 20),
                    _buildStartDateField(context),
                    SizedBox(height: 16),
                    _buildEndDateField(context),
                    SizedBox(height: 30),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(Get.context!).padding.top + 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Text(
              'إضافة دورة جديدة',
              style: ModernTheme.titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 40), // للموازنة
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return FadeInLeft(
      duration: Duration(milliseconds: 500),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return FadeInUp(
      duration: Duration(milliseconds: 600),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'اسم الدورة',
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.title, color: Colors.green),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'يرجى إدخال اسم الدورة' : null,
        ),
      ),
    );
  }

  Widget _buildChicksCountField() {
    return FadeInUp(
      duration: Duration(milliseconds: 700),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: chicksCountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'عدد الكتاكيت',
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.pets, color: Colors.green),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'مطلوب';
            if (int.tryParse(value!) == null) return 'أدخل رقم صحيح';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildStartDateField(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: startDateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'تاريخ البدء',
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              startDateController.text = date.toString().split(' ')[0];
            }
          },
          validator: (value) =>
              value?.isEmpty ?? true ? 'يرجى اختيار تاريخ البدء' : null,
        ),
      ),
    );
  }

  Widget _buildEndDateField(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 900),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: endDateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'تاريخ البيع المتوقع',
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.event, color: Colors.green),
            filled: true,
            fillColor: Colors.grey[50],
          ),
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
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              endDateController.text = date.toString().split(' ')[0];
            }
          },
          validator: (value) =>
              value?.isEmpty ?? true ? 'يرجى اختيار تاريخ البيع المتوقع' : null,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return FadeInUp(
      duration: Duration(milliseconds: 1000),
      child: Container(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final newCycle = Cycle(
                id: DateTime.now()
                    .millisecondsSinceEpoch
                    .toString(), // تأكد من أن الـ ID فريد
                name: nameController.text,
                startDate: DateTime.parse(startDateController.text),
                expectedSaleDate: DateTime.parse(endDateController.text),
                chicksCount: int.parse(chicksCountController.text),
                expenses: [],
              );
              controller.addNewCycle(newCycle);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
          ),
          child: Text(
            'إنشاء الدورة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
