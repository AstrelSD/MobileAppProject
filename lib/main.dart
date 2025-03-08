import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final PlatFormerGameDev platformer = PlatFormerGameDev();
  runApp(GameWidget(game: platformer));
}

