import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
 
class PlatFormerGameDev extends FlameGame {

  late final CameraComponent cam;
  final worl = Level();

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(world: worl, width: size.x, height: size.y);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, worl]);
    return super.onLoad();
  }
}
