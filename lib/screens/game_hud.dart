import 'package:flame/components.dart';
import 'dart:async';
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

class GameHud extends PositionComponent {
  int health = 3;
  int score = 0; // Score variable
  double elapsedTime = 0.0; // Timer variable

  late TextComponent healthCounter;
  late TextComponent scoreCounter;
  late TextComponent timerCounter;

  late TextPaint textPaint;  // Declare TextPaint

  @override
  FutureOr<void> onLoad() async {
    // Initialize TextPaint with styling (TextStyle)
    textPaint = TextPaint(
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    // Health display
    healthCounter = TextComponent(
      text: 'Health: $health',
      position: Vector2(10, 10),  // Adjust the position to top-left
    );
    healthCounter.textRenderer = textPaint;  // Apply textPaint here

    // Score display
    scoreCounter = TextComponent(
      text: 'Score: $score',
      position: Vector2(150, 10),  // Position it after health
    );
    scoreCounter.textRenderer = textPaint;  // Apply textPaint here

    // Timer display
    timerCounter = TextComponent(
      text: 'Time: 00:00',
      position: Vector2(300, 10),  // Position it after score
    );
    timerCounter.textRenderer = textPaint;  // Apply textPaint here

    // Add components to the game HUD
    add(healthCounter);
    add(scoreCounter);
    add(timerCounter);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the timer (elapsed time)
    elapsedTime += dt;
    int minutes = (elapsedTime / 60).floor();
    int seconds = (elapsedTime % 60).floor();
    timerCounter.text = 'Time: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    // Update score display (you can dynamically change this during gameplay)
    scoreCounter.text = 'Score: $score';
  }

  // Function to increase the score
  void increaseScore(int points) {
    score += points;
  }

  // Function to update health (you can call this whenever health changes)
  void updateHealth(int newHealth) {
    health = newHealth;
    healthCounter.text = 'Health: $health';
  }
}