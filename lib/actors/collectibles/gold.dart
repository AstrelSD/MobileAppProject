import 'package:flame/components.dart';
import 'package:mobile_app_roject/actors/collectibles/collectibles.dart';
import 'package:flame_audio/flame_audio.dart';

class Gold extends Collectible {
  Gold({required super.position})
      : super(
          type: CollectibleType.gold,
          value: 5,
          size: Vector2.all(16),
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('HUD/gold.png', images: game.images);
    await super.onLoad();
  }
  
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!collected) {
      collected = true;
      FlameAudio.play('coconutpickup.wav', volume: 1.0);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}