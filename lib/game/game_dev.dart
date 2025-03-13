import 'dart:async';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_3.dart';

class PlatFormerGameDev extends FlameGame {
  late Level currentLevel;
  final String initialLevel;

  final Map<String, Level Function()> gameLevels = {
    'level_3': () => Level3(),
  };

  PlatFormerGameDev({required this.initialLevel});

  @override
  Future<void> onLoad() async {
    await loadGame(initialLevel);
  }

  Future<void> loadGame(String level) async {
    // Remove only Level components from the world, not all children
    world.children.whereType<Level>().forEach(world.remove);

    if (gameLevels.containsKey(level)) {
      currentLevel = gameLevels[level]!();
      await world.add(currentLevel); // Ensure level is fully loaded
      print("Loaded $level successfully.");
    } else {
      print("Level $level not found!");
    }
  }
}
