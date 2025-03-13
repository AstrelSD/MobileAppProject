import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

class GameScreen extends StatelessWidget {
  final String initialLevel;

  const GameScreen({super.key, required this.initialLevel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: PlatFormerGameDev(initialLevel: initialLevel), // Loads the level
      ),
    );
  }
}
