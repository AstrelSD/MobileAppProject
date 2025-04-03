import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/actors/collectibles/gold.dart';
import 'package:mobile_app_roject/actors/collectibles/coin.dart';
import 'package:mobile_app_roject/actors/collectibles/coconut.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_1.dart';
import 'package:mobile_app_roject/levels/level_2.dart';
import 'package:mobile_app_roject/levels/level_3.dart';
import 'package:mobile_app_roject/screens/game_over_screen.dart';
import 'package:mobile_app_roject/screens/game_hud.dart';
import 'package:mobile_app_roject/screens/level_complete_screen.dart';
import 'package:mobile_app_roject/services/save_manager.dart';
import 'package:mobile_app_roject/models/game_state.dart';

class PlatFormerGameDev extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        TapCallbacks,
        HasCollisionDetection {
  late final CameraComponent cam;
  late Level activeLevel;
  final String initialLevel;
  final String character;
  late Character player;
  
  int score = 0;
  int coins = 0;
  int coconut = 0;
  int lives = 3;
  bool playSounds = false;
  double soundVolume = 1.0;
  int gold = 0;

  late final JoystickComponent joystick;
  late final ButtonComponent jumpButton;
  Character? playerReference;
  bool usingKeyboard = false;
  final keyboardKeysPressed = <LogicalKeyboardKey>{};

  late GameHud hud;
  final SaveManager saveManager = SaveManager();

  /// Getter for the current level
  String get currentLevel => activeLevel.levelName;

  PlatFormerGameDev({required this.initialLevel, required this.character});

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    overlays.addEntry('GameOver', (context, game) {
      return GameOverScreen(initialLevel: initialLevel, character: character);
    });

    overlays.addEntry('LevelComplete', (context, game) {
      return LevelCompleteScreen(initialLevel: initialLevel, character: character);
    });

    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFFB3E5FC),
    ));

    hud = GameHud();
    add(hud);

    addJoystick();
    addJumpButton();

    activeLevel = await loadLevel(initialLevel);
    await loadGame(activeLevel);

    debugMode = false;
    return super.onLoad();
  }

  Future<Level> loadLevel(String level) async {
    switch (level) {
      case '1': return Level1(character: character);
      case '2': return Level2(character: character);
      default:  return Level3(character: character);
    }
  }

  Future<void> loadGame(Level level) async {
    activeLevel = level;

    cam = CameraComponent.withFixedResolution(
      world: activeLevel,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.center;
    addAll([cam, activeLevel]);

    await activeLevel.ready;
    player = activeLevel.children.whereType<Character>().first;
    playerReference = player;
    cam.follow(player);
  }

  /// Handles collecting in-game items dynamically
  void collectItem(dynamic item) {
    if (item is Coin) {
      coins++;
    } else if (item is Gold) {
      gold++;
    } else if (item is Coconut) {
      coconut++;
    }

    item.removeFromParent(); // Remove collected item from the game
  }

  /// Resets the game and reloads the level
  void resetGame() {
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');

    score = 0;
    coins = 0;
    coconut = 0;
    gold = 0;
    lives = 3;

    removeAll(children);  // Clears all game components before reloading
    loadGame(activeLevel);
  }

  /// Saves the current game state
  Future<void> saveGame(int slot) async {
    await saveManager.saveGame(slot, GameState(
      level: int.parse(activeLevel.levelName),
      score: score,
      coins: coins,
      coconut: coconut,
      lives: lives,
      character: character,
      gold: gold,
      timestamp: DateTime.now().toUtc(),
    ));
  }

  void addJoystick() {
    final knob = SpriteComponent(
      sprite: Sprite(images.fromCache('HUD/Knob.png')),
    )..size = Vector2.all(64);

    final background = SpriteComponent(
      sprite: Sprite(images.fromCache('HUD/Joystick.png')),
    )..size = Vector2.all(150);

    joystick = JoystickComponent(
      knob: knob,
      background: background,
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    joystick.position = Vector2(100, size.y - 100);
    add(joystick);
  }

  void addJumpButton() {
    final button = SpriteComponent(
      sprite: Sprite(images.fromCache('HUD/JumpButton.png')),
    )..size = Vector2.all(64);

    jumpButton = ButtonComponent(
      button: button,
      position: Vector2(size.x - 100, size.y - 100),
      onPressed: () {
        if (playerReference != null && playerReference!.isOnGround) {
          playerReference!.jump();
          FlameAudio.play('jump.wav', volume: 1.0);
        }
      },
    );
    add(jumpButton);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    keyboardKeysPressed.clear();
    keyboardKeysPressed.addAll(keysPressed);
    usingKeyboard = keysPressed.isNotEmpty;

    if (playerReference != null &&
        playerReference!.isOnGround &&
        (keysPressed.contains(LogicalKeyboardKey.space) ||
            keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))) {
      playerReference!.jump();
    }

    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (playerReference == null) {
      findPlayerReference();
      return;
    }

    if (usingKeyboard) {
      handleKeyboardMovement();
    } else if (joystick.direction != JoystickDirection.idle) {
      handleJoystickMovement();
    } else {
      playerReference!.stopMoving();
    }
  }

  void handleKeyboardMovement() {
    final isLeftKeyPressed = keyboardKeysPressed.contains(LogicalKeyboardKey.keyA) ||
        keyboardKeysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keyboardKeysPressed.contains(LogicalKeyboardKey.keyD) ||
        keyboardKeysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerReference!.stopMoving();
    } else if (isLeftKeyPressed) {
      playerReference!.moveLeft();
    } else if (isRightKeyPressed) {
      playerReference!.moveRight();
    } else {
      playerReference!.stopMoving();
      usingKeyboard = false;
    }
  }

  void handleJoystickMovement() {
    final delta = joystick.delta;
    if (delta.x < -0.2) {
      playerReference!.moveLeft();
    } else if (delta.x > 0.2) {
      playerReference!.moveRight();
    } else {
      playerReference!.stopMoving();
    }
  }

  void findPlayerReference() {
    for (final component in activeLevel.children) {
      if (component is Character) {
        playerReference = component;
        break;
      }
    }
  }
}
