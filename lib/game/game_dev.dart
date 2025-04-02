import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_1.dart';
import 'package:mobile_app_roject/levels/level_2.dart';
import 'package:mobile_app_roject/levels/level_3.dart';
import 'package:mobile_app_roject/screens/game_over_screen.dart';
import 'package:mobile_app_roject/screens/game_hud.dart';
import 'package:mobile_app_roject/screens/level_complete_screen.dart';
import 'package:mobile_app_roject/screens/pause/pause_overlay.dart';
import 'package:mobile_app_roject/screens/platformer_main_menu.dart';
import 'package:mobile_app_roject/services/save_manager.dart';
import 'package:mobile_app_roject/models/game_state.dart';

class PlatFormerGameDev extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks, HasCollisionDetection {
  CameraComponent? cam; // Changed to nullable
  late Level activeLevel;
  final String initialLevel;
  final String character;
  late Character player;
  late final JoystickComponent joystick;
  late final ButtonComponent jumpButton;
  Character? playerReference;
  bool usingKeyboard = false;
  final keyboardKeysPressed = <LogicalKeyboardKey>{};
  late GameHud hud;
  late SaveManager saveManager;

  int currentLevel = 1;
  int score = 0;
  int coins = 0;
  int coconut = 0;
  int lives = 3;
  int selectedSaveSlot = 1;

  PlatFormerGameDev({required this.initialLevel, required this.character});

  @override
  Future<void> onLoad() async {
    saveManager = SaveManager();
    await images.loadAllImages();
    currentLevel = int.tryParse(initialLevel.replaceAll('level_', '')) ?? 1;

    _initializeOverlays();

    activeLevel = Level3(character: character);
    await loadGame(activeLevel);

    debugMode = true;
    hud = GameHud();
    add(hud);
    addJoystick();
    addJumpButton();
  }

  void _initializeOverlays() {
    overlays.addEntry('GameOver', (context, game) {
      return GameOverScreen(initialLevel: initialLevel, character: character);
    });

    overlays.addEntry('LevelComplete', (context, game) {
      return LevelCompleteScreen(initialLevel: initialLevel, character: character);
    });

    overlays.addEntry('PauseOverlay', (context, game) {
      return PauseOverlay(
        onResume: resumeGame,
        onRestart: resetGame,
        onSave: saveGame,
        level: currentLevel,
        score: score,
        coins: coins,
        coconut: coconut,
        lives: lives,
        character: character,
        saveManager: saveManager,
      );
    });
  }

  Future<void> loadGame(Level level) async {
    overlays.clear();

    hud = GameHud();
    add(hud);  // <-- Add the HUD to the game component tree
    // Clear existing components
    if (cam != null) {
      cam!.removeFromParent();
    }
    if (playerReference != null) {
      playerReference!.removeFromParent();
    }
    if (activeLevel.isMounted) {
      activeLevel.removeFromParent();
    }

    // Create new instances
    activeLevel = level;
    player = Character(character: character, position: Vector2(100, 200));
    playerReference = player;

    // Initialize camera
    cam = CameraComponent.withFixedResolution(width: 800, height: 600)
      ..viewfinder.anchor = Anchor.topLeft
      ..follow(player);

    // Add components in correct order
    world.add(activeLevel);
    world.add(player);
    add(cam!);
  }

  Future<void> saveGame() async {
    final gameState = GameState(
      level: currentLevel,
      score: score,
      coins: coins,
      coconut: coconut,
      lives: lives,
      character: character,
      timestamp: DateTime.now().toUtc(),
    );
    await saveManager.saveGame(selectedSaveSlot, gameState);
  }

  void pauseGame() {
    pauseEngine();
    overlays.add('PauseOverlay');
  }

  void resumeGame() {
    resumeEngine();
    overlays.remove('PauseOverlay');
  }

  void resetGame() {
    overlays.remove('PauseOverlay');
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    loadGame(activeLevel);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: Paint()..color = Colors.blue),
      background: CircleComponent(radius: 50, paint: Paint()..color = Colors.grey),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
      position: Vector2(100, size.y - 100),
    );
    add(joystick);
  }

  void addJumpButton() {
    jumpButton = ButtonComponent(
      button: CircleComponent(radius: 30, paint: Paint()..color = Colors.green),
      position: Vector2(size.x - 100, size.y - 100),
      onPressed: () => player.jump(),
    );
    add(jumpButton);
  }

  Future<void> loadSavedProgress(GameState savedState) async {
    currentLevel = savedState.level;
    score = savedState.score;
    coins = savedState.coins;
    coconut = savedState.coconut;
    lives = savedState.lives;

    await loadLevelBasedOnSavedState(savedState.level);
  }

  Future<void> loadLevelBasedOnSavedState(int level) async {
    Level newLevel;
    if (level == 1) {
      newLevel = Level1(character: character);
    } else if (level == 2) {
      newLevel = Level2(character: character);
    } else {
      newLevel = Level3(character: character);
    }

    await loadGame(newLevel);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (usingKeyboard) {
      if (keyboardKeysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.moveLeft();
      } else if (keyboardKeysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.moveRight();
      } else {
        player.stopMoving();
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      keyboardKeysPressed.add(event.logicalKey);
      usingKeyboard = true;
    } else if (event is KeyUpEvent) {
      keyboardKeysPressed.remove(event.logicalKey);
      usingKeyboard = false;
    }

    return KeyEventResult.handled;
  }
}
