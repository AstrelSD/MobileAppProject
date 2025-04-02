import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mobile_app_roject/actors/character.dart';

class Level extends World with HasCollisionDetection {
  late TiledComponent level;
  final String activeLevel;
  final Completer<void> _completer = Completer();
  late Character player;
  final String character;

  Level({required this.activeLevel, required this.character});
  String get levelName => activeLevel;

  Future<void> get ready => _completer.future;

  @override
  Future<void> onLoad() async {
    try {
      level = await TiledComponent.load(activeLevel, Vector2.all(16));
      add(level);

      final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('object1');
      if (spawnPointsLayer == null) {
        throw Exception('object1 layer not found in map');
      }

      bool playerFound = false;
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player = Character(
              character: character,
              position: Vector2(spawnPoint.x, spawnPoint.y),
            );
            add(player);
            playerFound = true;
            break;
        }
      }

      if (!playerFound) {
        throw Exception('Player spawn point not found in map');
      }

      final groundLayer = level.tileMap.getLayer<ObjectGroup>('ground');
      if (groundLayer != null) {
        for (final groundObj in groundLayer.objects) {
          final ground = Ground(
            position: Vector2(groundObj.x, groundObj.y),
            size: Vector2(groundObj.width, groundObj.height),
          );
          add(ground);
        }
      }

      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
    }
  }
}

class Ground extends PositionComponent with CollisionCallbacks {
  Ground({required super.position, required super.size}) {
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
    ));
  }
}

