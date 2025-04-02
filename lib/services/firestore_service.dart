import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save game data for a specific slot (1, 2, or 3)
  Future<void> saveGameData(int slot, Map<String, dynamic> data) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore.collection('users').doc(userId).set({
        'saveFile$slot': data
      }, SetOptions(merge: true));

      print("Save File $slot Updated!");
    } catch (e) {
      print("Error saving game: $e");
    }
  }

  /// Load game data from a specific slot
  Future<Map<String, dynamic>?> loadGameData(int slot) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? (doc.data() as Map<String, dynamic>)['saveFile$slot'] : null;
    } catch (e) {
      print("Error loading game: $e");
      return null;
    }
  }
}
