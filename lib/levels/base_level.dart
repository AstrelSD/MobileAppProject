import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

abstract class Level extends World {
  late TiledComponent level;
  final String activeLevel;
  PositionComponent? player;

  Level(this.activeLevel);

  @override
  Future<void> onLoad() async {
    try {
      level = await TiledComponent.load('tiles/$activeLevel', Vector2.all(16));
      add(level);

      loadLevelMechanics();

      print("Level $activeLevel loaded successfully.");
    } catch (e, stackTrace) {
      print("Error loading level $activeLevel: $e\n$stackTrace");
    }
  }

  // Abstract method for subclasses to implement level-specific logic
  void loadLevelMechanics();
}
