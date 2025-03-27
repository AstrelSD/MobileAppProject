import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_3.dart';

class PlatFormerGameDev extends FlameGame with TapCallbacks {
  late final CameraComponent cam;
  late final Level activeLevel;
  final String initialLevel;
  late Character player;

  PlatFormerGameDev({required this.initialLevel});

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    switch (initialLevel) {
      case 'level_3':
        activeLevel = Level3();
        break;
      default:
        activeLevel = Level3();
    }

    await _loadGame(activeLevel);
    return super.onLoad();
  }

  Future<void> _loadGame(Level level) async {
    cam = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.center;
    addAll([cam, level]);

    // Wait for the level to be fully loaded
    await level.ready;

    // Find the player character - we know it exists because level.ready completed
    player = level.children.whereType<Character>().first;
    cam.follow(player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.canvasPosition;
    final screenWidth = size.x;

    if (tapPosition.x < screenWidth / 2) {
      player.moveLeft();
    } else {
      player.moveRight();
    }
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    player.stopMoving();
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    player.stopMoving();
    super.onTapCancel(event);
  }
}
