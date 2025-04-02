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
import 'package:mobile_app_roject/levels/level_3.dart';
import 'package:mobile_app_roject/screens/game_over_screen.dart';
import 'package:mobile_app_roject/screens/pause/pause_overlay.dart';
import 'package:mobile_app_roject/models/game_state.dart';  

class PlatFormerGameDev extends FlameGame
    with HasCollisionDetection, TapCallbacks, DragCallbacks, KeyboardEvents {
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
  bool get isLeftPressed =>
      _pressedKeys.contains(LogicalKeyboardKey.keyA) ||
      _pressedKeys.contains(LogicalKeyboardKey.arrowLeft);
  bool get isRightPressed =>
      _pressedKeys.contains(LogicalKeyboardKey.keyD) ||
      _pressedKeys.contains(LogicalKeyboardKey.arrowRight);
  bool get isJumpPressed =>
      _pressedKeys.contains(LogicalKeyboardKey.keyW) ||
      _pressedKeys.contains(LogicalKeyboardKey.arrowUp) ||
      _pressedKeys.contains(LogicalKeyboardKey.space);

  bool isPaused = false;
  GameState gameState = GameState(
    level: 1,
    score: 0,
    coins: 0,
    gold: 0,
    lives: 3,
  );

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

    overlays.addEntry('Pause', (context, game) {
  return PauseOverlay(
    onResume: resumeGame,
    onRestart: restartGame,
    onSave: saveGame,
    level: gameState.level,  // Pass current level from game state
    score: gameState.score,  // Pass current score from game state
    coins: gameState.coins,  // Pass current coins from game state
    gold: gameState.gold,    // Pass current gold from game state
    lives: gameState.lives,  // Pass current lives from game state
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
    if (!isPaused) {
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
    }

    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        togglePause();
        return KeyEventResult.handled;
      }
    }

    _pressedKeys.clear();
    _pressedKeys.addAll(keysPressed);
    return KeyEventResult.handled;
  }

  void togglePause() {
    isPaused = !isPaused;
    if (isPaused) {
      overlays.add('Pause');
    } else {
      overlays.remove('Pause');
    }
  }

  void resumeGame() {
    isPaused = false;
    overlays.remove('Pause');
  }

  void restartGame() {
    isPaused = false;
    overlays.remove('Pause');
    overlays.remove('GameOver');
    _loadGame(activeLevel);
  }

  void saveGame() {
    // Implement your save game logic here
    print('Game saved!');
    // Example: Save player position, level progress, etc
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
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_isDragging) {
      _updateJoystickDelta(event.localPosition);
    }
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (_isDragging) {
      _isDragging = false;
      _joystickDelta = Vector2.zero();
      player.stopMoving();
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
}
