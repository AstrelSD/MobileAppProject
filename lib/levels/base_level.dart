import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

abstract class Level extends World {
  late TiledComponent level;
  final String activeLevel;

  Level(this.activeLevel);

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(activeLevel, Vector2.all(16));
    add(level);
    loadLevelMechanics(); 
  }

  void loadLevelMechanics(); 
}
