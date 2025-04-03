import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:mobile_app_roject/actors/character.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

enum CollectibleType { coin, gold, coconut }

abstract class Collectible extends SpriteComponent
    with HasGameRef<PlatFormerGameDev>, CollisionCallbacks {
  final CollectibleType type;
  final int value;

  Collectible({
    required this.type,
    required this.value,
    required super.position,
    required super.size,
  }) {
    add(RectangleHitbox());
  }

  bool collected = false;

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Character) {
      gameRef.collectItem(this);
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
