import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  String _getRemainingDays(DateTime start, DateTime end) {
    final today = DateTime.now();
    final remaining = end.difference(today).inDays;
    final total = end.difference(start).inDays;
    return 'متبقي $remaining من $total يوم';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        'مزرعتي',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.green[600],
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green[50]!, Colors.white],
        ),
      ),
    child: Column(
      children: [
        _buildAddCycleButton(),
        _buildNavigationButtons(),
        Expanded(child: Obx(() => _buildCyclesList())),
        
      ],
    ),
    ),
  );

  Widget _buildAddCycleButton() => Container(
    padding: EdgeInsets.all(16),
    child: ElevatedButton(
      onPressed: () => Get.toNamed('/add-cycle'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[600],
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, size: 24),
          SizedBox(width: 8),
          Text(
            'إضافة دورة جديدة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );

  Widget _buildCyclesList() =>
      controller.cycles.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.cycles.length,
            itemBuilder: (context, index) {
              final cycle = controller.cycles[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => controller.goToCycleDetails(cycle.id),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cycle.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${cycle.chicksCount} كتكوت',
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'تاريخ البدء: ${cycle.startDate.toString().split(' ')[0]}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          'تاريخ البيع: ${cycle.expectedSaleDate.toString().split(' ')[0]}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _getRemainingDays(
                            cycle.startDate,
                            cycle.expectedSaleDate,
                          ),
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value:
                              1 -
                              (cycle.expectedSaleDate
                                      .difference(DateTime.now())
                                      .inDays /
                                  cycle.expectedSaleDate
                                      .difference(cycle.startDate)
                                      .inDays),
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green[400]!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.nature_people_outlined, size: 80, color: Colors.green[300]),
        SizedBox(height: 16),
        Text(
          'لا توجد دورات حالية',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'ابدأ بإضافة دورة جديدة',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    ),
  );

  Widget _buildNavigationButtons() => Padding(
  padding: EdgeInsets.all(16),
  child: Row(
    children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () => Get.offAllNamed('/reports'),
          icon: Icon(Icons.assessment),
          label: Text('التقارير'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () {},
          // => Get.offAllNamed('/market'),
          icon: Icon(Icons.trending_up),
          label: Text('البورصة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ],
  ),
);

}
