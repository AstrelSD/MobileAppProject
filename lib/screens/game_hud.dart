import 'package:flutter/material.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

class GameHud extends StatelessWidget {
  final PlatFormerGameDev gameRef;

  const GameHud({
    super.key,
    required this.gameRef,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: GestureDetector(
        onTap: () => gameRef.togglePause(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'II',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
