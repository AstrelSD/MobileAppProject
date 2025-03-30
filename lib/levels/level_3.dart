import 'package:mobile_app_roject/levels/base_level.dart';

class Level3 extends Level {
  // Constructor only needs to pass character and activeLevel to the base class
  Level3({required String character}) : super(activeLevel: "level3.tmx", character: character);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); 
        print('Character selected: $character');
 // Load the base level (Tiled map)
    loadLevelMechanics();  // Add level-specific mechanics
  }

  @override
  void loadLevelMechanics() {
    // Example level-specific mechanics for Level3
    // Add enemies, power-ups, moving platforms, etc.
    print('Level3-specific mechanics added');
  }
}
