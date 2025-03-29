import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_3.dart';
import 'package:mobile_app_roject/actors/character.dart';
 
class PlatFormerGameDev extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks, KeyboardEvents {
  late final CameraComponent cam;
  late final Level activeLevel;
  late final JoystickComponent joystick;
  late final ButtonComponent jumpButton;
  Character? _playerReference;
  bool _usingKeyboard = false;
  final _keyboardKeysPressed = <LogicalKeyboardKey>{};
  
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    
    activeLevel = Level3();
    _loadGame(activeLevel);
    
    // Add joystick and jump button after game is loaded
    addJoystick();
    addJumpButton();
    
    return super.onLoad();
  }

  void _loadGame(Level level) {
    level = activeLevel;
    cam = CameraComponent.withFixedResolution(world: level, width: size.x, height: size.y);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, activeLevel]);
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
    
    // Configure joystick for horizontal movement only
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
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _keyboardKeysPressed.clear();
    _keyboardKeysPressed.addAll(keysPressed);
    
    // Set flag that keyboard is being used
    _usingKeyboard = keysPressed.isNotEmpty;
    
    // Check for jump key
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
    
    // Find player reference if not set
    if (_playerReference == null) {
      _findPlayerReference();
      return;
    }
    
    // Handle keyboard movement with priority over joystick
    if (_usingKeyboard) {
      _handleKeyboardMovement();
    }
    // Only use joystick if keyboard is not active
    else if (joystick.direction != JoystickDirection.idle) {
      _handleJoystickMovement();
    }
    // If no input, ensure character is idle
    else {
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
      _usingKeyboard = false; // Reset flag if no direction keys are pressed
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