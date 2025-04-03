import 'package:flame/components.dart';
import 'package:mobile_app_roject/actors/collectibles/collectibles.dart';

class Coconut extends Collectible {
  Coconut({required super.position})
      : super(
          type: CollectibleType.coconut,
          value: 10,
          size: Vector2.all(16),
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('HUD/coconut.png', images: game.images);
    await super.onLoad();
  }
}