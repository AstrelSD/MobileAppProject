import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_3.dart';

class PlatFormerGameDev extends FlameGame {
  late Level currentLevel;
  final String initialLevel;
  late final CameraComponent cameraComponent;

  final Map<String, Level Function()> gameLevels = {
    'level_3': () => Level3(),
  };

  PlatFormerGameDev({required this.initialLevel});

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    // Make sure world is assigned before initializing the camera
    world = World();
    add(world);

    // Initialize camera and assign it properly
    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    camera = cameraComponent;  // Assign to gameRef.camera
    add(cameraComponent);

    // Delay level loading slightly to ensure camera is initialized
    await Future.delayed(Duration(milliseconds: 50));

    await loadGame(initialLevel);
  }

  Future<void> loadGame(String level) async {
    // Remove previous level
    for (final level in world.children.whereType<Level>()) {
      level.removeFromParent();
    }

    if (gameLevels.containsKey(level)) {
      currentLevel = gameLevels[level]!();
      await world.add(currentLevel);

      // Ensure camera follows the player after level is added
      await Future.delayed(Duration(milliseconds: 50));
      _followPlayerIfAvailable();
    } else {
      throw Exception("Error: Level $level not found!");
    }
  }

  void _followPlayerIfAvailable() {
    if (currentLevel.player != null) {
      camera.follow(currentLevel.player!);
    } else {
      print("Warning: No player found to follow in ${currentLevel.runtimeType}.");
    }
  }
}
