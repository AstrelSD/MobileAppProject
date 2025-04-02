import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_roject/game/game_dev.dart';
import 'package:mobile_app_roject/levels/base_level.dart';

enum CharacterState { idle, running, jump }

enum CharacterDirection { left, right, none }

class Character extends SpriteAnimationGroupComponent<CharacterState>
    with HasGameRef<PlatFormerGameDev>, CollisionCallbacks, KeyboardHandler {
  final String character;
  final double speed = 200;
  final double jumpForce = -400;
  final double gravity = 800;
  final double stepTime = 0.05;

  CharacterDirection characterDirection = CharacterDirection.none;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  bool isJumping = false;
  bool isOnGround = false;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpAnimation;

  Character({required Vector2 position, required this.character})
      : super(position: position, size: Vector2.all(32));

  @override
  FutureOr<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(28, 30),
      position: Vector2(2, 2),
    ));

    loadCharacterAnimations();
    print('$character');
    current = CharacterState.idle;
    return super.onLoad();
  }

  void loadCharacterAnimations() {
    idleAnimation = _loadAsepriteAnimation('Idle', 1);
    runningAnimation = _loadAsepriteAnimation('Idle', 1);
    jumpAnimation = _loadAsepriteAnimation('Jump', 1);

    animations = {
      CharacterState.idle: idleAnimation,
      CharacterState.running: runningAnimation,
      CharacterState.jump: jumpAnimation,
    };
  }

  SpriteAnimation _loadAsepriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void moveLeft() {
    characterDirection = CharacterDirection.left;
    if (isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    }
  }

  void moveRight() {
    characterDirection = CharacterDirection.right;
    if (!isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
  }

  void stopMoving() {
    characterDirection = CharacterDirection.none;
    velocity.x = 0;
  }

  void jump() {
    if (isOnGround && !isJumping) {
      velocity.y = jumpForce;
      isOnGround = false;
      isJumping = true;
      current = CharacterState.jump;
    }
  }

  @override
  void update(double dt) {
    _updateCharacterMovement(dt);
    _updateJump(dt);
    checkGameOver();
    checkLevelComplete();
    super.update(dt);
  }

  void checkGameOver() {
    if (position.y > gameRef.size.y + 100) {
      gameRef.overlays.add('GameOver');
    }
  }

  void checkLevelComplete() {
    final endObjects = gameRef.activeLevel.level.tileMap
        .getLayer<ObjectGroup>('object1')
        ?.objects
        .where((obj) => obj.class_ == 'END');

    if (endObjects != null && endObjects.isNotEmpty) {
      final end = endObjects.first;
      final endRect = Rect.fromLTWH(
        end.x,
        end.y,
        end.width,
        end.height,
      );

      final playerRect = Rect.fromLTWH(
        position.x,
        position.y,
        size.x,
        size.y,
      );

      if (playerRect.overlaps(endRect)) {
        gameRef.overlays.add('LevelComplete');
      }
    }
  }

  void _updateCharacterMovement(double dt) {
    double dirX = 0.0;
    switch (characterDirection) {
      case CharacterDirection.left:
        dirX -= speed;
        if (!isJumping) current = CharacterState.running;
        break;
      case CharacterDirection.right:
        dirX += speed;
        if (!isJumping) current = CharacterState.running;
        break;
      case CharacterDirection.none:
        if (!isJumping) current = CharacterState.idle;
        dirX = 0;
        break;
    }
    velocity.x = dirX;
    position.x += velocity.x * dt;
  }

  void _updateJump(double dt) {
    if (!isOnGround) {
      velocity.y += gravity * dt;
      position.y += velocity.y * dt;
      current = CharacterState.jump;
    } else {
      velocity.y = 0;
      isJumping = false;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ground) {
      if (intersectionPoints.length == 2) {
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;
        if (position.y < mid.y) {
          isOnGround = true;
          position.y = other.position.y - size.y;
          velocity.y = 0;
        }
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Ground) {
      isOnGround = false;
    }
    super.onCollisionEnd(other);
  }
}

