import 'package:flame/components.dart';
import 'package:mobile_app_roject/actors/collectibles/collectibles.dart';
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
}
