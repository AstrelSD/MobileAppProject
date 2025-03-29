import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_3.dart';
import 'package:mobile_app_roject/screens/game_over_screen.dart';

class PlatFormerGameDev extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  late final CameraComponent cam;
  late final Level activeLevel;
  final String initialLevel;
  late Character player;

  PlatFormerGameDev({required this.initialLevel});

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    // Register overlay
    overlays.addEntry('GameOver', (context, game) {
      return GameOverScreen(initialLevel: initialLevel);
    });

    activeLevel = Level3();
    await _loadGame(activeLevel);

    debugMode = true;
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

    await level.ready;
    player = level.children.whereType<Character>().first;
    cam.follow(player);
  }

  void resetGame() {
    overlays.remove('GameOver');
    _loadGame(activeLevel);
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
