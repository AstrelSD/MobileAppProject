import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/actors/collectibles/coconut.dart';
import 'package:mobile_app_roject/actors/collectibles/coin.dart';
import 'package:mobile_app_roject/actors/collectibles/gold.dart';
import 'package:flame/components.dart';
import 'dart:async'; // Add this for Completer

class Level3 extends Level {
  Level3({required super.character}) : super(activeLevel: "level2_map.tmx");
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
    final collectiblesLayer = level.tileMap.getLayer<ObjectGroup>('collectibles');
    if (collectiblesLayer != null) {
      await _loadCollectibles(collectiblesLayer);
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


Future<void> _loadCollectibles(ObjectGroup collectiblesLayer) async {
  for (final collectible in collectiblesLayer.objects) {
    final position = Vector2(collectible.x, collectible.y);
    switch (collectible.class_) {
      case 'Coin':
        add(Coin(position: position));
        break;
      case 'Gold':
        add(Gold(position: position));
        break;
      case 'Coconut':
        add(Coconut(position: position));
        break;
        }
        }
    }
}