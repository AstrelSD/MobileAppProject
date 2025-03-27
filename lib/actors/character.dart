import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

enum CharacterState { idle, running, jump }

enum CharacterDirection { left, right, none }

class Character extends SpriteAnimationGroupComponent<CharacterState>
    with HasGameRef<PlatFormerGameDev> {
  final String character;
  final double _speed = 200;
  final double _jumpForce = -300;
  final double _gravity = 0;

  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isFacingRight = true;
  CharacterDirection direction = CharacterDirection.none;

  Character({required Vector2 position, required this.character})
      : super(position: position);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpAnimation;

  @override
  FutureOr<void> onLoad() async {
    await _loadCharacterAnimations();
    return super.onLoad();
  }

  _loadCharacterAnimations() {
    idleAnimation = _loadAsepriteAnimation('Idle', 11);
    runningAnimation = _loadAsepriteAnimation('Run', 12);
    jumpAnimation = _loadAsepriteAnimation('Jump', 1);

    animations = {
      CharacterState.idle: idleAnimation,
      CharacterState.running: runningAnimation,
      CharacterState.jump: jumpAnimation,
    };

    current = CharacterState.idle;
  }

  SpriteAnimation _loadAsepriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  void moveLeft() {
    direction = CharacterDirection.left;
    if (isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    }
  }

  void moveRight() {
    direction = CharacterDirection.right;
    if (!isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
  }

  void stopMoving() {
    direction = CharacterDirection.none;
  }

  @override
  void update(double dt) {
    _updateMovement(dt);
    super.update(dt);
  }

  void _updateMovement(double dt) {
    velocity.x = 0;

    switch (direction) {
      case CharacterDirection.left:
        velocity.x = -_speed;
        current = CharacterState.running;
        break;
      case CharacterDirection.right:
        velocity.x = _speed;
        current = CharacterState.running;
        break;
      case CharacterDirection.none:
        if (velocity.x == 0) {
          current = CharacterState.idle;
        }
        break;
    }

    // Apply gravity
    velocity.y += _gravity * dt;

    // Update position
    position += velocity * dt;

    // Simple ground collision (for testing)
    if (position.y > gameRef.size.y - 100) {
      position.y = gameRef.size.y - 100;
      velocity.y = 0;
      isOnGround = true;
      if (velocity.x == 0) {
        current = CharacterState.idle;
      }
    }
  }
}
