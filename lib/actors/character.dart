import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:mobile_app_roject/game/game_dev.dart';
import 'package:mobile_app_roject/levels/base_level.dart';

enum CharacterState { idle, running, jump }

enum CharacterDirection { left, right, none }

class Character extends SpriteAnimationGroupComponent<CharacterState>
    with HasGameRef<PlatFormerGameDev>, CollisionCallbacks {
  final String character;
  final double _speed = 200;
  final double _jumpForce = -500;
  final double _gravity = 800;

  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isFacingRight = true;
  CharacterDirection direction = CharacterDirection.none;
  bool isMoving = false;

  Character({required Vector2 position, required this.character})
      : super(position: position, size: Vector2.all(32));

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpAnimation;

  @override
  FutureOr<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(28, 30),
      position: Vector2(2, 2),
      isSolid: true,
    ));

    await _loadCharacterAnimations();

    current = CharacterState.idle;
    isOnGround = false;

    return super.onLoad();
  }

  Future<void> _loadCharacterAnimations() async {
    idleAnimation = await _loadAsepriteAnimation('Idle', 11);
    runningAnimation = await _loadAsepriteAnimation('Run', 12);
    jumpAnimation = await _loadAsepriteAnimation('Jump', 1);

    animations = {
      CharacterState.idle: idleAnimation,
      CharacterState.running: runningAnimation,
      CharacterState.jump: jumpAnimation,
    };
  }

  Future<SpriteAnimation> _loadAsepriteAnimation(
      String state, int amount) async {
    return SpriteAnimation.fromFrameData(
      await game.images.load('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void moveLeft() {
    direction = CharacterDirection.left;
    isMoving = true;
    if (isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    }
  }

  void moveRight() {
    direction = CharacterDirection.right;
    isMoving = true;
    if (!isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
  }

  void stopMoving() {
    direction = CharacterDirection.none;
    isMoving = false;
    velocity.x = 0;
  }

  void jump() {
    if (isOnGround) {
      velocity.y = _jumpForce;
      isOnGround = false;
      current = CharacterState.jump;
    }
  }

  @override
  void update(double dt) {
    _updateMovement(dt);
    _checkGameOver();
    super.update(dt);
  }

  void _checkGameOver() {
    if (position.y > gameRef.size.y + 100) {
      gameRef.overlays.add('GameOver');
    }
  }

  void _updateMovement(double dt) {
    if (!isOnGround) {
      velocity.y += _gravity * dt;
    } else {
      velocity.y = 0;
    }

    if (isMoving) {
      switch (direction) {
        case CharacterDirection.left:
          velocity.x = -_speed;
          if (isOnGround) current = CharacterState.running;
          break;
        case CharacterDirection.right:
          velocity.x = _speed;
          if (isOnGround) current = CharacterState.running;
          break;
        case CharacterDirection.none:
          velocity.x = 0;
          if (isOnGround) current = CharacterState.idle;
          break;
      }
    } else {
      velocity.x = 0;
      if (isOnGround) current = CharacterState.idle;
    }

    position += velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ground) {
      _handleGroundCollision(intersectionPoints, other);
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Ground) {
      isOnGround = false;
      if (current != CharacterState.jump) {
        current = CharacterState.jump;
      }
    }
    super.onCollisionEnd(other);
  }

  void _handleGroundCollision(Set<Vector2> intersectionPoints, Ground ground) {
    final min = intersectionPoints.reduce(
        (a, b) => Vector2(a.x < b.x ? a.x : b.x, a.y < b.y ? a.y : b.y));
    final max = intersectionPoints.reduce(
        (a, b) => Vector2(a.x > b.x ? a.x : b.x, a.y > b.y ? a.y : b.y));

    final collisionNormal =
        (absoluteCenter - (min + (max - min) / 2)).normalized();

    if (collisionNormal.y < -0.5) {
      position.y = ground.position.y - size.y;
      velocity.y = 0;
      isOnGround = true;
      if (!isMoving) {
        current = CharacterState.idle;
      }
    } else if (collisionNormal.y > 0.5) {
      position.y = ground.position.y + ground.size.y;
      velocity.y = 0;
    } else if (collisionNormal.x < -0.5) {
      position.x = ground.position.x + ground.size.x;
      velocity.x = 0;
    } else if (collisionNormal.x > 0.5) {
      position.x = ground.position.x - size.x;
      velocity.x = 0;
    }
  }
}
