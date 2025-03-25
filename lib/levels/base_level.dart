import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

abstract class Level extends World {
  late TiledComponent level;
  final String activeLevel;

  Level(this.activeLevel);

  @override
  Future<void> onLoad() async {
  try {
    level = await TiledComponent.load('tiles/$activeLevel', Vector2.all(16));
    add(level);
    loadLevelMechanics();
  } catch (e) {
    print("Error loading level $activeLevel: $e");
  }
}

  void loadLevelMechanics(); 
}
