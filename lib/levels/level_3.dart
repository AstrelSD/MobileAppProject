import 'package:mobile_app_roject/levels/base_level.dart';

class Level3 extends Level {
  Level3() : super(activeLevel: "level3.tmx");

  @override
  Future<void> onLoad() async {
    await super.onLoad();  // Load the base level (Tiled map)
    loadLevelMechanics();  // Add level-specific mechanics
  }

  @override
  void loadLevelMechanics() {
    // Level-specific mechanics for Level3
    // Example: Add enemies, power-ups, platforms, etc.
  }
}
