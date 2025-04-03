import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

class GameHud extends PositionComponent with HasGameRef<PlatFormerGameDev> {
  late TextComponent coinText;
  late TextComponent goldText;
  late TextComponent coconutText;
  late TextComponent timerText;
  
  
  late Sprite coinIcon;
  late Sprite goldIcon;
  late Sprite coconutIcon;
  
  late SpriteComponent coinIconComponent;
  late SpriteComponent goldIconComponent;
  late SpriteComponent coconutIconComponent;

  double _timer = 0.0;

  @override
  Future<void> onLoad() async {

  final hudBackground = RectangleComponent(
  size: Vector2(gameRef.size.x, 36),
  position: Vector2.zero(),
  paint: Paint()..color = Colors.black.withOpacity(0.5),
);
add(hudBackground);
    // Load icons
    coinIcon = await Sprite.load('HUD/coin.png', images: game.images);
    goldIcon = await Sprite.load('HUD/gold.png', images: game.images);
    coconutIcon = await Sprite.load('HUD/coconut.png', images: game.images);

    // Create icon components
    coinIconComponent = SpriteComponent(
      sprite: coinIcon,
      size: Vector2.all(16),
      position: Vector2(20, 10),
    );
    
    goldIconComponent = SpriteComponent(
      sprite: goldIcon,
      size: Vector2.all(16),
      position: Vector2(100, 10),
    );
    
    coconutIconComponent = SpriteComponent(
      sprite: coconutIcon,
      size: Vector2.all(16),
      position: Vector2(180, 10),
    );

    // Create text components
    coinText = TextComponent(
      text: '0',
      position: Vector2(40, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: 'PixelFont',
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );

    goldText = TextComponent(
      text: '0',
      position: Vector2(120, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.yellow,
          fontFamily: 'PixelFont',
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );

    coconutText = TextComponent(
      text: '0',
      position: Vector2(200, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.brown,
          fontFamily: 'PixelFont',
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );

    timerText = TextComponent(
      text: '00:00',
      position: Vector2(gameRef.size.x - 80, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: 'PixelFont',
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );

    // Add all components to HUD
    addAll([
      coinIconComponent,
      goldIconComponent,
      coconutIconComponent,
      coinText,
      goldText,
      coconutText,
      timerText,
    ]);
  }

  void update(double dt) {
    super.update(dt);
    // Update the timer
    _timer += dt;
    int minutes = _timer ~/ 60;
    int seconds = _timer.toInt() % 60;
    timerText.text =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void updateHud(int coins, int gold, int coconuts) {
    coinText.text = '$coins';
    goldText.text = '$gold';
    coconutText.text = '$coconuts';
  }
  
}