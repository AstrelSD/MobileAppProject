import 'package:flame/components.dart';
import 'package:mobile_app_roject/levels/base_level.dart';

//This override is to test if tile loads
class Level3 extends Level {
  Level3() : super(activeLevel: "level3.tmx"); // Assuming it's a Tiled map

  @override
  Future<void> onLoad() async {
    final game = findGame();

    final sprite = await Sprite.load("Idle (32x32).png");
    final background = SpriteComponent(
      sprite: sprite,
      size: game?.size, // Use the game screen size
      anchor: Anchor.topLeft,
    );
    add(background);
    await super.onLoad();
    loadLevelMechanics();
  }

  @override
  void loadLevelMechanics() {
    // Add level-specific mechanics here
  }
}
