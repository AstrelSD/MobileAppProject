import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveProgress(int level, int score) async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).set({
      'level': level,
      'score': score,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getProgress() async {
    String uid = _auth.currentUser!.uid;
    return await _firestore.collection('users').doc(uid).get();
  }
}
