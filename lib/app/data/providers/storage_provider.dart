// lib/app/data/providers/storage_provider.dart

import 'package:get_storage/get_storage.dart';
import '../models/cycle.dart';

class StorageProvider {
  static final StorageProvider _instance = StorageProvider._internal();
  factory StorageProvider() => _instance;
  StorageProvider._internal();

  final storage = GetStorage();
  final String cyclesKey = 'cycles';

  // حفظ الدورات
  Future<void> saveCycles(List<Cycle> cycles) async {
    try {
      final cyclesData = cycles.map((cycle) => cycle.toJson()).toList();
      await storage.write(cyclesKey, cyclesData);
    } catch (e) {
      print('Error saving cycles: $e');
      throw Exception('Failed to save cycles');
    }
  }

  // قراءة الدورات
  Future<List<Cycle>> loadCycles() async {
    try {
      final savedCycles = storage.read<List>(cyclesKey) ?? [];
      return savedCycles.map((cycleData) => Cycle.fromJson(cycleData)).toList();
    } catch (e) {
      print('Error loading cycles: $e');
      return [];
    }
  }

  // حذف دورة محددة
  Future<void> deleteCycle(String cycleId) async {
    try {
      final cycles = await loadCycles();
      cycles.removeWhere((cycle) => cycle.id == cycleId);
      await saveCycles(cycles);
    } catch (e) {
      print('Error deleting cycle: $e');
      throw Exception('Failed to delete cycle');
    }
  }

  // تحديث دورة محددة
  Future<void> updateCycle(Cycle updatedCycle) async {
    try {
      final cycles = await loadCycles();
      final index = cycles.indexWhere((cycle) => cycle.id == updatedCycle.id);
      if (index != -1) {
        cycles[index] = updatedCycle;
        await saveCycles(cycles);
      }
    } catch (e) {
      print('Error updating cycle: $e');
      throw Exception('Failed to update cycle');
    }
  }

  // حذف جميع البيانات
  Future<void> clearAllData() async {
    try {
      await storage.erase();
    } catch (e) {
      print('Error clearing data: $e');
      throw Exception('Failed to clear data');
    }
  }

  // التحقق من وجود بيانات
  Future<bool> hasData() async {
    return storage.hasData(cyclesKey);
  }
}