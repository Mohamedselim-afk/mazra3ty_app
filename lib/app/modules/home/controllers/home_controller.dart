import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/cycle.dart';
import '../../../data/providers/remote_config.dart';
import '../../../data/providers/storage_provider.dart';

class HomeController extends GetxController {
  // Services
  final storageProvider = StorageProvider();
  final _firestore = FirebaseFirestore.instance;
  final _remoteConfig = RemoteConfigService();

  // Observable variables
  final cycles = <Cycle>[].obs;
  final isLoading = true.obs;
  final isFeatureEnabled = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _initializeRemoteConfig();
      await loadCycles();
    } catch (e) {
      print('Error initializing app: $e');
    }
  }

  Future<void> _initializeRemoteConfig() async {
  await _remoteConfig.initialize();
  
  // Check maintenance mode
  if (_remoteConfig.isMaintenanceMode) {
    Get.dialog(
      AlertDialog(
        title: Text('تنبيه'),
        content: Text('التطبيق في وضع الصيانة حالياً'),
        actions: [
          TextButton(
            child: Text('حسناً'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
    return;
  }

  // Check required update
  if (_remoteConfig.requiresUpdate) {
    Get.dialog(
      AlertDialog(
        title: Text('تحديث مطلوب'),
        content: Text('يرجى تحديث التطبيق إلى أحدث إصدار'),
        actions: [
          TextButton(
            child: Text('تحديث'),
            onPressed: () {
              // TODO: Implement app store redirection
            },
          ),
        ],
      ),
    );
    return;
  }

  // Update feature flags
  isFeatureEnabled.value = _remoteConfig.getFeatureFlag('new_features');
}


  Future<void> loadCycles() async {
    try {
      isLoading.value = true;
      
      // Load from both local storage and Firebase
      final localCycles = await storageProvider.loadCycles();
      final firebaseSnapshot = await _firestore.collection('cycles').get();
      final firebaseCycles = firebaseSnapshot.docs.map((doc) => Cycle.fromJson(doc.data())).toList();
      
      // Merge cycles, prioritizing Firebase data
      final Map<String, Cycle> mergedCycles = {};
      
      // Add local cycles
      for (var cycle in localCycles) {
        mergedCycles[cycle.id] = cycle;
      }
      
      // Override with Firebase cycles
      for (var cycle in firebaseCycles) {
        mergedCycles[cycle.id] = cycle;
      }
      
      cycles.assignAll(mergedCycles.values.toList());
      
      // Sync local storage with merged data
      await storageProvider.saveCycles(cycles);
      
    } catch (e) {
      print('Error loading cycles: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

void goToCycleDetails(String cycleId) {
  if (!_remoteConfig.getFeatureFlag('cycle_details')) {
    Get.snackbar(
      'تنبيه',
      'هذه الميزة غير متاحة حالياً',
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[800],
    );
    return;
  }
  Get.toNamed('/cycle-details', arguments: cycleId);
}

  Future<void> addNewCycle(Cycle cycle) async {
    try {
      // Validate using Remote Config
      if (!_validateNewCycle(cycle)) {
        return;
      }

      // Add to local list
      cycles.add(cycle);
      
      // Save to local storage
      await storageProvider.saveCycles(cycles);
      
      // Save to Firebase
      await _firestore.collection('cycles').doc(cycle.id).set(cycle.toJson());
      
      Get.back();
      Get.snackbar(
        'تم بنجاح',
        'تم إضافة الدورة ${cycle.name}',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      print('Error adding cycle: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حفظ البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  bool _validateNewCycle(Cycle cycle) {
    // Add any validation logic based on Remote Config
    final maxChicksCount = _remoteConfig.remoteConfig.getInt('max_chicks_count');
    if (maxChicksCount > 0 && cycle.chicksCount > maxChicksCount) {
      Get.snackbar(
        'خطأ',
        'عدد الكتاكيت يتجاوز الحد المسموح به ($maxChicksCount)',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }
    return true;
  }

  Future<void> updateCycle(Cycle updatedCycle) async {
    try {
      final index = cycles.indexWhere((cycle) => cycle.id == updatedCycle.id);
      if (index != -1) {
        // Update local list
        cycles[index] = updatedCycle;
        
        // Update local storage
        await storageProvider.saveCycles(cycles);
        
        // Update Firebase
        await _firestore.collection('cycles')
            .doc(updatedCycle.id)
            .update(updatedCycle.toJson());
            
        Get.snackbar(
          'تم بنجاح',
          'تم تحديث الدورة ${updatedCycle.name}',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      }
    } catch (e) {
      print('Error updating cycle: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // Delete from local storage only
  Future<void> deleteLocalCycle(String cycleId) async {
    try {
      cycles.removeWhere((cycle) => cycle.id == cycleId);
      await storageProvider.saveCycles(cycles);
      
      Get.snackbar(
        'تم الحذف',
        'تم حذف الدورة من التطبيق',
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
    } catch (e) {
      print('Error deleting local cycle: $e');
      throw e;
    }
  }

  // Delete from both local storage and Firebase
  Future<void> deleteFullCycle(String cycleId) async {
    try {
      // Delete from local list
      cycles.removeWhere((cycle) => cycle.id == cycleId);
      
      // Delete from local storage
      await storageProvider.saveCycles(cycles);
      
      // Delete from Firebase
      await _firestore.collection('cycles').doc(cycleId).delete();
      
      Get.snackbar(
        'تم الحذف',
        'تم حذف الدورة من التطبيق والسيرفر',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      print('Error deleting cycle completely: $e');
      throw e;
    }
  }

  // Sync specific cycle with Firebase
  Future<void> syncWithFirebase(String cycleId) async {
    try {
      final cycle = cycles.firstWhere((c) => c.id == cycleId);
      await _firestore.collection('cycles').doc(cycleId).set(cycle.toJson());
      
      Get.snackbar(
        'تم المزامنة',
        'تم مزامنة البيانات مع السيرفر',
        backgroundColor: Colors.blue[100],
        colorText: Colors.blue[800],
      );
    } catch (e) {
      print('Error syncing with Firebase: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء مزامنة البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // Force refresh from Firebase
  Future<void> refreshFromFirebase() async {
    try {
      isLoading.value = true;
      final firebaseSnapshot = await _firestore.collection('cycles').get();
      final firebaseCycles = firebaseSnapshot.docs.map((doc) => Cycle.fromJson(doc.data())).toList();
      
      cycles.assignAll(firebaseCycles);
      await storageProvider.saveCycles(cycles);
      
      Get.snackbar(
        'تم التحديث',
        'تم تحديث البيانات من السيرفر',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      print('Error refreshing from Firebase: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث البيانات',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Cleanup if needed
    super.onClose();
  }
}