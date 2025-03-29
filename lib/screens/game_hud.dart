import 'dart:async';

import 'package:flame/components.dart';

class GameHud extends PositionComponent {
  int health = 3;
  @override
  FutureOr<void> onLoad() {
    late final TextComponent healthCounter;

    healthCounter = TextComponent(
      text: 'Health: $health',
      position: Vector2(0, 30),
    );
    add(healthCounter);
  }
}
