import 'package:mobile_app_roject/levels/base_level.dart';

class Level1 extends Level {
  Level1({required super.character}) : super(activeLevel: "level1.tmx");

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('Character selected: $character');
    loadLevelMechanics();
  // Constructor only needs to pass character and activeLevel to the base class
  Level1({required String character}) 
      : super(activeLevel: "level1.tmx", character: character);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); 
        print('Character selected: $character');
 // Load the base level (Tiled map)
    loadLevelMechanics();  // Add level-specific mechanics
  }

  @override
  void loadLevelMechanics() {
    print('Level3-specific mechanics added');
    // Example level-specific mechanics for Level1
    // Add enemies, power-ups, moving platforms, etc.
    print('Level1-specific mechanics added');
  }
}
