import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class GameHud extends PositionComponent {
  int health = 3;
  
  @override
  Future<void> onLoad() async {
    final healthText = TextComponent(
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
  }
}