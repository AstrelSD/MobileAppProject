import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_3.dart';
import 'package:mobile_app_roject/screens/game_hud.dart';

class PlatFormerGameDev extends FlameGame {
  late final CameraComponent cam;
  late final Level activeLevel;
  late GameHud hud;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    activeLevel = Level3();
    hud = GameHud();
    _loadGame(activeLevel);
    return super.onLoad();
  }

  void _loadGame(Level level) {
    level = activeLevel;
    cam = CameraComponent.withFixedResolution(
    world: level, width: size.x, height: size.y);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, hud, activeLevel]);
  }
}
