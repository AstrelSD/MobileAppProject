import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

class GameScreen extends StatefulWidget {
  final String initialLevel;
  final String character;

  const GameScreen({
    super.key,
    required this.initialLevel,
    required this.character,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final PlatFormerGameDev game;

  @override
  void initState() {
    super.initState();
    game = PlatFormerGameDev(
      initialLevel: widget.initialLevel,
      character: widget.character,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: game,
      ),
    );
  }
}
