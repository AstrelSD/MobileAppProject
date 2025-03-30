import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_1.dart';
import 'package:mobile_app_roject/levels/level_3.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/screens/game_hud.dart';

class PlatFormerGameDev extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks, KeyboardEvents {
  late final CameraComponent cam;
  late final Level activeLevel;
  final String character;

  PlatFormerGameDev({required this.character});
  late final JoystickComponent joystick;
  late final ButtonComponent jumpButton;
  Character? _playerReference;
  bool _usingKeyboard = false;
  final _keyboardKeysPressed = <LogicalKeyboardKey>{};

  late GameHud hud;  // Declare the GameHud for displaying score and timer
  double elapsedTime = 0.0;  // Define elapsedTime to track the time in seconds

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    hud = GameHud();  // Initialize the HUD
    print('Character selected: $character');
    activeLevel = Level1(character: character);  // Load Level 1 (or any other level)
    _loadGame(activeLevel, character);
    addJoystick();
    addJumpButton();
    return super.onLoad();
  }

  void _loadGame(Level level, String character) {
    cam = CameraComponent.withFixedResolution(
      world: level, width: size.x, height: size.y);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, hud, activeLevel]);  // Add camera, HUD, and active level to the game
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    joystick.position = Vector2(100, size.y - 100);
    add(joystick);
  }

  void addJumpButton() {
    jumpButton = ButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/JumpButton.png')),
        size: Vector2.all(64),
      ),
      position: Vector2(size.x - 100, size.y - 100),
      onPressed: () {
        if (_playerReference != null && !_playerReference!.isJumping) {
          _playerReference!.jump();
        }
      },
    );
    add(jumpButton);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keyboardKeysPressed.clear();
    _keyboardKeysPressed.addAll(keysPressed);

    _usingKeyboard = keysPressed.isNotEmpty;

    if (_playerReference != null &&
        !_playerReference!.isJumping &&
        (keysPressed.contains(LogicalKeyboardKey.space) ||
         keysPressed.contains(LogicalKeyboardKey.keyW) ||
         keysPressed.contains(LogicalKeyboardKey.arrowUp))) {
      _playerReference!.jump();
    }

    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update elapsed time to keep track of time in the game
    elapsedTime += dt;  // Increment elapsedTime by the delta time

    // Example: increase score every 2 second
    if (elapsedTime >= 2) {
      hud.increaseScore(1);  // Increase score by 1 every 2 second
      elapsedTime = 0;  // Reset elapsed time after updating the score
    }

    // Check and initialize player reference
    if (_playerReference == null) {
      _findPlayerReference();
      return;
    }

    // Handle player movement using keyboard or joystick
    if (_usingKeyboard) {
      _handleKeyboardMovement();
    } else if (joystick.direction != JoystickDirection.idle) {
      _handleJoystickMovement();
    } else {
      _playerReference!.characterDirection = CharacterDirection.none;
    }
  }

  void _handleKeyboardMovement() {
    final isLeftKeyPressed = _keyboardKeysPressed.contains(LogicalKeyboardKey.keyA) ||
        _keyboardKeysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = _keyboardKeysPressed.contains(LogicalKeyboardKey.keyD) ||
        _keyboardKeysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      _playerReference!.characterDirection = CharacterDirection.none;
    } else if (isLeftKeyPressed) {
      _playerReference!.characterDirection = CharacterDirection.left;
    } else if (isRightKeyPressed) {
      _playerReference!.characterDirection = CharacterDirection.right;
    } else {
      _playerReference!.characterDirection = CharacterDirection.none;
      _usingKeyboard = false;  // Reset flag if no direction keys are pressed
    }
  }

  void _handleJoystickMovement() {
    final delta = joystick.delta;

    if (delta.x < -0.2) {
      _playerReference!.characterDirection = CharacterDirection.left;
    } else if (delta.x > 0.2) {
      _playerReference!.characterDirection = CharacterDirection.right;
    } else {
      _playerReference!.characterDirection = CharacterDirection.none;
    }
  }

  void _findPlayerReference() {
    // Find the player component in the active level
    for (final component in activeLevel.children) {
      if (component is Character) {
        _playerReference = component;
        break;
      }
    }
  }
}
