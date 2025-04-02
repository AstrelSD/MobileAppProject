import 'package:flutter/material.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

class GameHud extends PositionComponent {
  int health = 3;
  int score = 0;
  double timeElapsed = 0.0;
  double scoreTimer = 0.0; // Accumulator for score update

  late final TextComponent healthText;
  late final TextComponent scoreText;
  late final TextComponent timerText;

  @override
  Future<void> onLoad() async {
    // Health display
    healthText = TextComponent(
      text: 'Health: $health',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Color.fromARGB(255, 235, 225, 225),
        ),
      ),
    );
    add(healthText);

    // Score display
    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(200, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Color.fromARGB(255, 235, 225, 225),
        ),
      ),
    );
    add(scoreText);

    // Timer display
    timerText = TextComponent(
      text: 'Time: ${timeElapsed.toStringAsFixed(1)}',
      position: Vector2(400, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Color.fromARGB(255, 235, 225, 225),
        ),
      ),
    );
    add(timerText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update the timer display
    timeElapsed += dt;
    timerText.text = 'Time: ${timeElapsed.toStringAsFixed(1)}';

    // Accumulate dt and update the score every 0.75 seconds
    scoreTimer += dt;
    if (scoreTimer >= 0.75) {
      score++;
      scoreText.text = 'Score: $score';
      scoreTimer -= 0.75;
    }
  }
}
