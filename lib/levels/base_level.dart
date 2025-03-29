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

  Level({required this.activeLevel});

  Future<void> get ready => _completer.future;

  Future<void> loadLevel() async {
    try {
      level = await TiledComponent.load('$activeLevel', Vector2.all(16));
      add(level);

      final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('object1');
      if (spawnPointsLayer == null) {
        throw Exception('object1 layer not found in map');
      }

      bool playerFound = false;
      for (final spawnPoint in spawnPointsLayer.objects) {
        if (spawnPoint.class_ == 'Player') {
          player = Character(
            character: 'Virtual Guy',
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

          ground.add(RectangleHitbox(
            size: Vector2(groundObj.width, groundObj.height),
            position: Vector2.zero(),
            isSolid: true,
          ));
        }
      }

      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
      rethrow;
    }
  }

  @override
  Future<void> onLoad() async {
    await loadLevel();
    return super.onLoad();
  }
}

class Ground extends PositionComponent with CollisionCallbacks {
  Ground({required super.position, required super.size});
}
