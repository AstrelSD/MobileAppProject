import 'package:flame/components.dart';
import 'package:mobile_app_roject/levels/base_level.dart';

//This override is to test if tile loads
class Level3 extends Level {
  Level3() : super("Mountain.tmx"); // Assuming it's a Tiled map

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Load the Tiled map first

    // Load a background image
    final sprite = await Sprite.load("Mou.png");

    // Get the game reference
    final game = findGame()!;
    
    final background = SpriteComponent(
      sprite: sprite,
      size: game.size, // Use the game screen size
      anchor: Anchor.topLeft,
    );

    add(background);
  }

  @override
  void loadLevelMechanics() {
    // Add level-specific mechanics here
  }
}
