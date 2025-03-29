import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

class GameScreen extends StatelessWidget {
  final String initialLevel;
  final String character;

  const GameScreen({super.key, required this.initialLevel, required this.character});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: PlatFormerGameDev( 
          character: character
        ), // Loads the level
      ),
    );
  }
}
