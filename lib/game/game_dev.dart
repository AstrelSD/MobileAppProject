import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/levels/base_level.dart';
import 'package:mobile_app_roject/levels/level_1.dart';
import 'package:mobile_app_roject/levels/level_3.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/screens/game_hud.dart';
import 'package:mobile_app_roject/screens/game_over_screen.dart';


class PlatFormerGameDev extends FlameGame 
    with HasCollisionDetection, TapCallbacks, DragCallbacks, KeyboardEvents {

class PlatFormerGameDev extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks, KeyboardEvents {
  late final CameraComponent cam;
  late final Level activeLevel;
  final String initialLevel;
  final String character;
  late Character player;
  
  late Sprite _joystickBackground;
  late Sprite _joystickKnob;
  late Vector2 _joystickPosition;
  late double _joystickRadius;
  late double _knobRadius;
  Vector2 _joystickDelta = Vector2.zero();
  bool _isDragging = false;
  
  late Sprite _jumpButton;
  late Vector2 _jumpButtonPosition;
  late double _jumpButtonSize;
  bool _isJumpPressed = false;

  final Set<LogicalKeyboardKey> _pressedKeys = {};
  bool get isLeftPressed => _pressedKeys.contains(LogicalKeyboardKey.keyA) || 
                          _pressedKeys.contains(LogicalKeyboardKey.arrowLeft);
  bool get isRightPressed => _pressedKeys.contains(LogicalKeyboardKey.keyD) || 
                           _pressedKeys.contains(LogicalKeyboardKey.arrowRight);
  bool get isJumpPressed => _pressedKeys.contains(LogicalKeyboardKey.keyW) || 
                          _pressedKeys.contains(LogicalKeyboardKey.arrowUp) || 
                          _pressedKeys.contains(LogicalKeyboardKey.space);

  PlatFormerGameDev({required this.initialLevel, required this.character});

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

    overlays.addEntry('GameOver', (context, game) {
      return GameOverScreen(
        initialLevel: initialLevel,
        character: character,
      );
    });


    _joystickBackground = await Sprite.load('HUD/Joystick.png');
    _joystickKnob = await Sprite.load('HUD/Knob.png');
    _jumpButton = await Sprite.load('HUD/JumpButton.png');

    _joystickRadius = 50;
    _knobRadius = 25;
    _joystickPosition = Vector2(100, size.y - 100);
    
    _jumpButtonSize = 80;
    _jumpButtonPosition = Vector2(size.x - 100, size.y - 100);

    activeLevel = Level3(character: character);
    await _loadGame(activeLevel);

    debugMode = true;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    _joystickBackground.render(
      canvas,
      position: _joystickPosition - Vector2.all(_joystickRadius),
      size: Vector2.all(_joystickRadius * 2),
    );
    
    final knobPosition = _joystickPosition + _joystickDelta;
    _joystickKnob.render(
      canvas,
      position: knobPosition - Vector2.all(_knobRadius),
      size: Vector2.all(_knobRadius * 2),
    );
    
    _jumpButton.render(
      canvas,
      position: _jumpButtonPosition - Vector2.all(_jumpButtonSize / 2),
      size: Vector2.all(_jumpButtonSize),
    );
  }

  @override
  void update(double dt) {
    if (isLeftPressed) {
      player.moveLeft();
    } else if (isRightPressed) {
      player.moveRight();
    } else if (!_isDragging) {
      player.stopMoving();
    }

    if (isJumpPressed) {
      player.jump();
    }

    if (_isDragging) {
      final direction = _joystickDelta.normalized();
      if (direction.x < -0.5) {
        player.moveLeft();
      } else if (direction.x > 0.5) {
        player.moveRight();
      }
    }

    if (_isJumpPressed) {
      player.jump();
    }

    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _pressedKeys.clear();
    _pressedKeys.addAll(keysPressed);
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
  void onTapDown(TapDownEvent event) {
    final jumpButtonArea = Rect.fromCenter(
      center: _jumpButtonPosition.toOffset(),
      width: _jumpButtonSize,
      height: _jumpButtonSize,
    );
    
    if (jumpButtonArea.contains(event.localPosition.toOffset())) {
      _isJumpPressed = true;
    }
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _isJumpPressed = false;
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _isJumpPressed = false;
    super.onTapCancel(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    final joystickArea = Rect.fromCenter(
      center: _joystickPosition.toOffset(),
      width: _joystickRadius * 2,
      height: _joystickRadius * 2,
    );
    
    if (joystickArea.contains(event.localPosition.toOffset())) {
      _isDragging = true;
      _updateJoystickDelta(event.localPosition);
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
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_isDragging) {
      _updateJoystickDelta(event.localPosition);
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
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (_isDragging) {
      _isDragging = false;
      _joystickDelta = Vector2.zero();
      player.stopMoving();
  void _handleJoystickMovement() {
    final delta = joystick.delta;

    if (delta.x < -0.2) {
      _playerReference!.characterDirection = CharacterDirection.left;
    } else if (delta.x > 0.2) {
      _playerReference!.characterDirection = CharacterDirection.right;
    } else {
      _playerReference!.characterDirection = CharacterDirection.none;
    }
    super.onDragEnd(event);
  }

  void _updateJoystickDelta(Vector2 touchPosition) {
    _joystickDelta = touchPosition - _joystickPosition;
    if (_joystickDelta.length > _joystickRadius) {
      _joystickDelta = _joystickDelta.normalized() * _joystickRadius;
    }
  }

  Future<void> _loadGame(Level level) async {
    cam = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.center;
    addAll([cam, level]);

    await level.ready;
    player = level.children.whereType<Character>().first;
    cam.follow(player);
  }

  void resetGame() {
    overlays.remove('GameOver');
    _loadGame(activeLevel);
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
