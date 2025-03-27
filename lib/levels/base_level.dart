import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;
  final String activeLevel;

  // Constructor to accept the level map file
  Level({required this.activeLevel});

  Future<void> loadLevel() async {
    level = await TiledComponent.load(activeLevel, Vector2.all(16));
    add(level);
  }

  @override
  Future<void> onLoad() async {
    await loadLevel(); // Loads the specific level dynamically
    return super.onLoad();
  }

  void loadLevelMechanics() {
    // Override in subclasses for level-specific mechanics
  }
}
