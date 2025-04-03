import 'package:mobile_app_roject/levels/base_level.dart';

class Level3 extends Level {
  Level3({required super.character}) : super(activeLevel: "level2_map.tmx");

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    loadLevelMechanics();
  }

  @override
  void loadLevelMechanics() {
    // Level-specific mechanics here
  }
}
