import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

enum CharacterState { idle, running, jump }

enum CharacterDirection { left, right, none }

class Character extends SpriteAnimationGroupComponent<CharacterState> with HasGameRef<PlatFormerGameDev> {
  final String character;

  Character({required Vector2 position, this.character = 'Virtual Guy'}) : super(position: position);

  final double stepTime = 0.05;
  
  CharacterDirection characterDirection = CharacterDirection.none;
  double movespeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  
  // Jump parameters
  bool isJumping = false;
  double jumpForce = -300;
  double gravity = 800;
  double floorHeight = 0; // This will be set based on level collision

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpAnimation;

  @override
  FutureOr<void> onLoad() async {
    await _loadCharacterAnimations();
    // Set initial floor height based on spawn position
    floorHeight = position.y;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateCharacterMovement(dt);
    _updateJump(dt);
    super.update(dt);
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

    current = CharacterState.idle; // Set initial state
  }

  SpriteAnimation _loadAsepriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32)
      )
    );
  }
  
  void _updateCharacterMovement(double dt) {
    double dirX = 0.0;
    switch (characterDirection) {
      case CharacterDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        dirX -= movespeed;
        if (!isJumping) {
          current = CharacterState.running;
        }
        break;
      case CharacterDirection.right:
        dirX += movespeed;
        if (!isJumping) {
          current = CharacterState.running;
        }
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        break;
      case CharacterDirection.none:
        if (!isJumping) {
          current = CharacterState.idle;
        }
        dirX = 0;
        break;
      default:
    }

    velocity.x = dirX;
    position.x += velocity.x * dt;
  }
  
  void jump() {
    if (!isJumping) {
      isJumping = true;
      velocity.y = jumpForce;
      current = CharacterState.jump;
    }
  }
  
  void _updateJump(double dt) {
    if (isJumping) {
      // Apply gravity
      velocity.y += gravity * dt;
      position.y += velocity.y * dt;
      
      // Check if character has landed
      if (position.y >= floorHeight) {
        position.y = floorHeight;
        isJumping = false;
        velocity.y = 0;
        
        // Reset animation state
        if (characterDirection == CharacterDirection.none) {
          current = CharacterState.idle;
        } else {
          current = CharacterState.running;
        }
      }
    }
  }
}