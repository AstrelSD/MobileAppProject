import 'package:flame/components.dart';
import 'package:mobile_app_roject/actors/collectibles/collectibles.dart';

class Coin extends Collectible {
  Coin({required super.position})
      : super(
          type: CollectibleType.coin,
          value: 1,
          size: Vector2.all(16),
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('HUD/coin.png', images: game.images);
    await super.onLoad();
  }
}


