import 'package:flame/components.dart';
import 'package:mobile_app_roject/actors/collectibles/collectibles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mobile_app_roject/actors/character.dart';

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

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Character && !collected) {
      collected = true;
      print("Coconut collected!"); 
      try {
        FlameAudio.play('coconutpickup.wav', volume: 1.0);
        print("Attempting to play coconut sound");
      } catch (e) {
        print("Error playing coconut sound: $e");
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}