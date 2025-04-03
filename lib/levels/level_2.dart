import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'dart:async'; // Add this for Completer

class Level2 extends Level {
  Level2({required super.character}) : super(activeLevel: "level2.tmx");
  final Completer<void> _completer = Completer(); 
  

  @override
  Future<void> onLoad() async {
    // Load the map with 32x32 tile size
    level = await TiledComponent.load(activeLevel, Vector2.all(32));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('object1');
    if (spawnPointsLayer == null) {
      throw Exception('object1 layer not found in map');
    }

    bool playerFound = false;
    for (final spawnPoint in spawnPointsLayer.objects) {
      if (spawnPoint.class_ == 'Player') {
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

    loadLevelMechanics();

    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  @override
  void loadLevelMechanics() {
  }

  @override
  Future<void> get ready => _completer.future;
}
