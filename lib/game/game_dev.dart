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
    if (world.children.isNotEmpty) {
      world.children.whereType<Level>().forEach(world.remove);
    }

    if (gameLevels.containsKey(level)) {
      currentLevel = gameLevels[level]!();
      await world.add(currentLevel);
      print("Loaded $level successfully.");
    } else {
      throw Exception("Error: Level $level not found!");
    }
  }
}
