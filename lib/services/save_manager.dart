import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game_state.dart';

class SaveManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save game progress to a specific slot
  Future<void> saveGame(int slot, GameState gameState) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('saveSlots')
        .doc('slot_$slot')
        .set(gameState.toJson());

    print('Game saved in Slot $slot');
  }

  // Load game progress from a specific slot
  Future<GameState?> loadGame(int slot) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('saveSlots')
        .doc('slot_$slot')
        .get();

    if (snapshot.exists) {
      return GameState.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      print('No save data found in Slot $slot');
      return null;
    }
  }

  // Check which save slots are used
  Future<List<int>> getUsedSlots() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('saveSlots')
        .get();

    return snapshot.docs.map((doc) => int.parse(doc.id.split('_')[1])).toList();
  }
}
