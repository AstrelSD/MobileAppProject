import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart'; // Import flame_audio
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

@override
void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
  if (!collected) {
    collected = true;
    print("Coin collected!"); // Debugging log
    FlameAudio.play('coinpickup.wav'); // Play sound effect
  }
  super.onCollisionStart(intersectionPoints, other);
}

}
