import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/parallax.dart';

void main() {
  runApp(GameWidget(game: ProjectGame()));
}

class ProjectGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the parallax background
    final mountainBackground = await loadParallaxComponent(
      [
        ParallaxImageData('sea2.png'),
      ],
      baseVelocity: Vector2(10, 0), // Moves the background horizontally
      velocityMultiplierDelta: Vector2(1.6, 1.0),
    );

    // Add the parallax background to the game
    add(mountainBackground);
  }
}
