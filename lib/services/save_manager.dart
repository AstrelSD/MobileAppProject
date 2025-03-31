import '../services/firestore_service.dart';

class SaveManager {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> saveGame(int slot, int progress, Map<String, dynamic> resources) async {
    await _firestoreService.saveGameData(slot, {
      'progress': progress,
      'resources': resources,
    });
  }

  Future<Map<String, dynamic>?> loadGame(int slot) async {
    return await _firestoreService.loadGameData(slot);
  }
}
