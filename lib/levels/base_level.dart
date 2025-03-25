import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mobile_app_roject/actors/character.dart';

abstract class Level extends World {
  late TiledComponent level;
  final String activeLevel;
  PositionComponent? player;

  Level({required this.activeLevel});

  @override
  Future<void> onLoad() async {
    try {
      level = await TiledComponent.load('tiles/$activeLevel', Vector2.all(16));
      add(level);
      final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnpoints');
      for (final spawnPoint in spawnPointsLayer!.objects) {
        switch (spawnPoint.class_) {
          case 'Character':
            final character = Character(character: "character", position: Vector2(spawnPoint.x, spawnPoint.y));
            add(character);
          break;
        }
      }

      loadLevelMechanics();

      print("Level $activeLevel loaded successfully.");
    } catch (e, stackTrace) {
      print("Error loading level $activeLevel: $e\n$stackTrace");
    }
  }

  // Abstract method for subclasses to implement level-specific logic
  void loadLevelMechanics();
}
