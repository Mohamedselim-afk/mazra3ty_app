import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cycle.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String COLLECTION_NAME = 'cycles';
  
  // Add cycle to Firestore
  Future<void> addCycle(Cycle cycle) async {
    try {
      print('Adding cycle to Firestore - ID: ${cycle.id}');
      print('Cycle data: ${cycle.toJson()}');
      
      await _firestore.collection(COLLECTION_NAME)
        .doc(cycle.id)
        .set(cycle.toJson(), SetOptions(merge: true));
      
      print('Successfully added cycle to Firestore');
    } catch (e) {
      print('Error adding cycle to Firestore: $e');
      print('Stack trace: ${StackTrace.current}');
      throw e;
    }
  }

  // Get all cycles from Firestore
  Future<List<Cycle>> getCycles() async {
    try {
      print('Fetching cycles from Firestore');
      final snapshot = await _firestore.collection(COLLECTION_NAME).get();
      
      print('Retrieved ${snapshot.docs.length} cycles from Firestore');
      final cycles = snapshot.docs.map((doc) {
        print('Processing cycle document ID: ${doc.id}');
        return Cycle.fromJson(doc.data());
      }).toList();
      
      print('Successfully converted all documents to Cycle objects');
      return cycles;
    } catch (e) {
      print('Error getting cycles from Firestore: $e');
      print('Stack trace: ${StackTrace.current}');
      throw e;
    }
  }

  // Update cycle in Firestore
  Future<void> updateCycle(Cycle cycle) async {
    try {
      print('Updating cycle in Firestore - ID: ${cycle.id}');
      print('Updated data: ${cycle.toJson()}');
      
      await _firestore.collection(COLLECTION_NAME)
        .doc(cycle.id)
        .update(cycle.toJson());
      
      print('Successfully updated cycle in Firestore');
    } catch (e) {
      print('Error updating cycle in Firestore: $e');
      print('Stack trace: ${StackTrace.current}');
      throw e;
    }
  }

  // Delete cycle from Firestore
  Future<void> deleteCycle(String cycleId) async {
    try {
      print('Deleting cycle from Firestore - ID: $cycleId');
      
      await _firestore.collection(COLLECTION_NAME)
        .doc(cycleId)
        .delete();
      
      print('Successfully deleted cycle from Firestore');
    } catch (e) {
      print('Error deleting cycle from Firestore: $e');
      print('Stack trace: ${StackTrace.current}');
      throw e;
    }
  }

  // Test Firestore connection
  Future<bool> testConnection() async {
    try {
      print('Testing Firestore connection');
      
      // Try to write to a test collection
      final testDoc = await _firestore.collection('test')
        .add({
          'timestamp': FieldValue.serverTimestamp(),
          'test': true
        });
      
      // Try to read it back
      final docSnapshot = await testDoc.get();
      
      // Clean up test document
      await testDoc.delete();
      
      print('Firestore connection test successful');
      return true;
    } catch (e) {
      print('Firestore connection test failed: $e');
      print('Stack trace: ${StackTrace.current}');
      return false;
    }
  }
}