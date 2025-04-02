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
import 'package:mobile_app_roject/screens/game_over_screen.dart';
import 'package:mobile_app_roject/screens/game_hud.dart';
import 'package:mobile_app_roject/screens/level_complete_screen.dart';

class PlatFormerGameDev extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        TapCallbacks,
        HasCollisionDetection {
  late final CameraComponent cam;
  late final Level activeLevel;
  final String initialLevel;
  final String character;
  late Character player;

  late final JoystickComponent joystick;
  late final ButtonComponent jumpButton;
  Character? playerReference;
  bool usingKeyboard = false;
  final keyboardKeysPressed = <LogicalKeyboardKey>{};

  late GameHud hud;

  PlatFormerGameDev({required this.initialLevel, required this.character});

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    overlays.addEntry('GameOver', (context, game) {
      return GameOverScreen(
        initialLevel: initialLevel,
        character: character,
      );
    });

    overlays.addEntry('LevelComplete', (context, game) {
      return LevelCompleteScreen(
        initialLevel: initialLevel,
        character: character,
      );
    });

    activeLevel = Level1(character: character);
    await loadGame(activeLevel);

    debugMode = false;
    hud = GameHud();
    add(hud); // HUD added to UI layer

    addJoystick();
    addJumpButton();
    return super.onLoad();
  }

  Future<void> loadGame(Level level) async {
    cam = CameraComponent.withFixedResolution(
      world: level,
      width: canvasSize.x,
      height: canvasSize.y,
    )
      ..viewfinder.anchor = Anchor.topLeft
      ..viewfinder.zoom = 2.0; // Zoom in the world

    addAll([cam, level]);

    await level.ready;
    player = level.children.whereType<Character>().first;
    playerReference = player;
    cam.follow(player, horizontalOnly: true); // Follow only in X-direction
  }

  void resetGame() {
    overlays.remove('GameOver');
    loadGame(activeLevel);
  }

  void addJoystick() {
    final knob = SpriteComponent(
       paint: Paint()..color = Colors.white,
      sprite: Sprite(images.fromCache('HUD/Knob.png')),
    )..size = Vector2.all(64);

    final background = SpriteComponent(
      sprite: Sprite(images.fromCache('HUD/Joystick.png')),
    )..size = Vector2.all(150);

    joystick = JoystickComponent(
      knob: knob,
      background: background,
      margin: const EdgeInsets.only(left: 32, bottom: 32), // Fixed position
    );

    add(joystick..priority = 10); // Joystick stays above map
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
        }
      },
    );

    add(jumpButton..priority = 10); // Ensures button is above the map
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
    final isLeftKeyPressed =
        keyboardKeysPressed.contains(LogicalKeyboardKey.keyA) ||
            keyboardKeysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keyboardKeysPressed.contains(LogicalKeyboardKey.keyD) ||
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

  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.canvasPosition;
    final screenWidth = size.x;

    if (tapPosition.x < screenWidth / 2) {
      player.moveLeft();
    } else {
      player.moveRight();
    }
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    player.stopMoving();
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    player.stopMoving();
    super.onTapCancel(event);
  }
}
