import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cycle.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Add cycle to Firestore
  Future<void> addCycle(Cycle cycle) async {
    try {
      await _firestore.collection('cycles').doc(cycle.id).set(cycle.toJson());
    } catch (e) {
      print('Error adding cycle to Firestore: $e');
      throw e;
    }
  }

  // Get all cycles from Firestore
  Future<List<Cycle>> getCycles() async {
    try {
      final snapshot = await _firestore.collection('cycles').get();
      return snapshot.docs.map((doc) => Cycle.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting cycles from Firestore: $e');
      throw e;
    }
  }

  // Update cycle in Firestore
  Future<void> updateCycle(Cycle cycle) async {
    try {
      await _firestore.collection('cycles').doc(cycle.id).update(cycle.toJson());
    } catch (e) {
      print('Error updating cycle in Firestore: $e');
      throw e;
    }
  }

  // Delete cycle from Firestore
  Future<void> deleteCycle(String cycleId) async {
    try {
      await _firestore.collection('cycles').doc(cycleId).delete();
    } catch (e) {
      print('Error deleting cycle from Firestore: $e');
      throw e;
    }
  }
}