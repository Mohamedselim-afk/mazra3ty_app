import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animate_do/animate_do.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../../../core/theme/modern_theme.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: ModernTheme.animatedBackground,
        child: Stack(
          children: [
            _buildAnimatedBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildNavigationCards(),
                  Expanded(child: Obx(() => _buildCyclesList())),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: ElasticIn(
        duration: Duration(seconds: 2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.withOpacity(0.1),
                Colors.blue.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: Duration(milliseconds: 800),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ShakeX(
              duration: Duration(milliseconds: 3000),
              child: Text(
                'مزرعتي',
                style: ModernTheme.titleStyle.copyWith(
                  color: Colors.green[800],
                  fontSize: 32,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'إدارة دورات التربية بسهولة',
              style: ModernTheme.subtitleStyle.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ZoomIn(
              delay: Duration(milliseconds: 300),
              child: _buildNavCard(
                'التقارير',
                Icons.assessment_outlined,
                () => Get.toNamed('/reports'),
                gradient: ModernTheme.primaryGradient,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ZoomIn(
              delay: Duration(milliseconds: 500),
              child: // In HomeView
                  _buildNavCard(
                'البورصة',
                Icons.trending_up,
                () => Get.toNamed(Routes.MARKET), // Update this line
                gradient: ModernTheme.secondaryGradient,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavCard(
    String title,
    IconData icon,
    VoidCallback onTap, {
    required Gradient gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        onEnter: (_) {},
        onExit: (_) {},
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                style: ModernTheme.subtitleStyle.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCyclesList() {
    if (controller.cycles.isEmpty) {
      return _buildEmptyState();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: controller.cycles.length,
        itemBuilder: (context, index) {
          final cycle = controller.cycles[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(child: _buildCycleCard(cycle)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCycleCard(cycle) {
    return GestureDetector(
      onTap: () => controller.goToCycleDetails(cycle.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: ModernTheme.modernCardDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              _buildProgressBackground(cycle.progressPercentage),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cycle.name, style: ModernTheme.subtitleStyle),
                        _buildChicksCountBadge(cycle.chicksCount),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildDateInfo('تاريخ البدء:', cycle.startDate),
                    _buildDateInfo('تاريخ البيع:', cycle.expectedSaleDate),
                    SizedBox(height: 12),
                    _buildRemainingDays(cycle),
                    SizedBox(height: 8),
                    _buildProgressIndicator(cycle.progressPercentage),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChicksCountBadge(int count) {
    return Flash(
      // infinite: true,
      duration: Duration(seconds: 2),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: ModernTheme.primaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              '$count كتكوت',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey[600])),
          SizedBox(width: 8),
          Text(date.toString().split(' ')[0], style: ModernTheme.bodyStyle),
        ],
      ),
    );
  }

  Widget _buildRemainingDays(cycle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: Colors.green[700]),
          SizedBox(width: 8),
          Text(
            'متبقي ${cycle.remainingDays} يوم',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تقدم الدورة',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Container(
              height: 6,
              width: (Get.width - 80) * value,
              decoration: BoxDecoration(
                gradient: ModernTheme.primaryGradient,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBackground(double value) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[300]!, Colors.green[700]!],
            stops: [0, value],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: BounceInDown(
        duration: Duration(milliseconds: 1500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // الخيار 1: كتكوت
                  Icon(
                    Icons.flutter_dash, // شكل كتكوت جميل
                    size: 60,
                    color: Colors.yellow[600],
                  ),

                  // أو يمكنك استخدام أحد هذه الخيارات:
                  // Icons.pets_outlined - كتكوت بتفاصيل خطية
                  // Icons.emoji_nature - شكل طبيعي
                  // Icons.flutter_dash - شكل لطيف لطائر

                  // عشب في الأسفل
                  // Positioned(
                  //   bottom: 0,
                  //   child: Icon(
                  //     Icons.grass,
                  //     size: 40,
                  //     color: Colors.green[400],
                  //   ),
                  // ),
                  // شمس في الأعلى
                  Positioned(
                    top: -5,
                    right: -3,
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      size: 20,
                      color: Colors.orange[300],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'لا توجد دورات حالية',
              style: ModernTheme.subtitleStyle.copyWith(
                color: Colors.green[800],
              ),
            ),
            // SizedBox(height: 8),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.green[50],
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(
            //       color: Colors.green[100]!,
            //       width: 1,
            //     ),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(
            //         Icons.add_circle_outline,
            //         size: 20,
            //         color: Colors.green[600],
            //       ),
            //       SizedBox(width: 8),
            //       Text(
            //         'ابدأ بإضافة دورة جديدة',
            //         style: TextStyle(
            //           color: Colors.green[600],
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Pulse(
      infinite: false,
      duration: Duration(seconds: 2),
      child: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/add-cycle'),
        backgroundColor: Colors.green[700],
        icon: Icon(Icons.add_circle_outline, color: Colors.white),
        label: Text('إضافة دورة', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
