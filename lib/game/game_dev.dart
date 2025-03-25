import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_3.dart';

class PlatFormerGameDev extends FlameGame {
  late Level currentLevel;
  final String initialLevel;
  late final CameraComponent camera;

  final Map<String, Level Function()> gameLevels = {
    'level_3': () => Level3(),
  };

  PlatFormerGameDev({required this.initialLevel});

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();
    camera = CameraComponent(world: world);
    camera.viewfinder.anchor = Anchor.topLeft;
    add(camera);
    await loadGame(initialLevel);
  }

  Future<void> loadGame(String level) async {
    for (final level in world.children.whereType<Level>()) {
      level.removeFromParent();
    }

    if (gameLevels.containsKey(level)) {
      currentLevel = gameLevels[level]!();
      await world.add(currentLevel);

      _followPlayerIfAvailable();
    } else {
      throw Exception("Error: Level $level not found!");
    }
  }

  void _followPlayerIfAvailable() {
    if (currentLevel.player != null) {
      camera.follow(currentLevel.player!);
    } else {
      print(
          "Warning: No player found to follow in ${currentLevel.runtimeType}.");
    }
  }
}
