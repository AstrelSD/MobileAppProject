import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/game/game_dev.dart';
import 'package:mobile_app_roject/screens/settings/settings_overlay.dart';
import 'package:mobile_app_roject/screens/pause/pause_overlay.dart';
import 'package:mobile_app_roject/game/game_dev.dart';


class GameScreen extends StatefulWidget {
  final String initialLevel;
  final String character;

  const GameScreen(
      {super.key, required this.initialLevel, required this.character});

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
      body: Stack(
        children: [
          GameWidget(
            game: game,
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const SettingsOverlay(),
                  barrierColor: Colors.black.withOpacity(0.5),
                );
              },
            ),
          ),
           Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.pause,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () {
  game.pauseEngine();
  showDialog(
    context: context,
    builder: (context) => PauseOverlay(
      onResume: () => game.resumeEngine(),
      onRestart: () {
        game.resetGame(); // Ensure this function resets the game correctly
      },
      onSave: () async {
        await game.saveGame(); // Call the correct save function
      },
      level: game.currentLevel,  // Fetch level from game instance
      score: game.score,         // Fetch score from game instance
      coins: game.coins,         // Fetch coins from game instance
      coconut: game.coconut,           // Fetch gold from game instance
      lives: game.lives, 
      character: widget.character,        // Fetch lives from game instance
      saveManager: game.saveManager, // Pass SaveManager instance from game
    ),
    barrierColor: Colors.black.withOpacity(0.5),
  ).then((_) => game.resumeEngine());
},

            ),
          ),
        ],
      ),
    );
  }
}