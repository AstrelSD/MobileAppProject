 import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';

late TiledComponent level;

class Level extends World {
  @override
  FutureOr<void> onLoad() async {

    level = await TiledComponent.load("level3.tmx", Vector2.all(16));
    add(level);
    return super.onLoad();
  }
}