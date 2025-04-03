import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:mobile_app_roject/game/game_dev.dart';
import 'package:mobile_app_roject/screens/settings/settings_overlay.dart';
import 'package:mobile_app_roject/screens/pause/pause_overlay.dart';
import 'package:mobile_app_roject/models/game_state.dart';


class GameScreen extends StatefulWidget {
  final String initialLevel;
  final String character;
  final GameState? loadedState;

  const GameScreen({
    super.key,
    required this.initialLevel,
    required this.character,
    this.loadedState,
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
      initialLevel: widget.loadedState?.level != null
          ? 'level_${widget.loadedState!.level}' 
          : widget.initialLevel, 
      character: widget.character,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            top: 40,
            right: 80,
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
                    onRestart: () => game.resetGame(),
                    onSave: () async {
                      await game.saveGame(1); // Saving to slot 1
                    },
                    level: int.tryParse(game.activeLevel.levelName) ?? 1,
                    score: game.score,
                    coins: game.coins,
                    gold: game.gold,
                    coconut: game.coconut,
                    lives: game.lives,
                    character: widget.character,
                    saveManager: game.saveManager,
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
