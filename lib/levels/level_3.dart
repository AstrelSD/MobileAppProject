import 'package:mobile_app_roject/levels/base_level.dart';

class Level2 extends Level {
  Level2({required super.character}) : super(activeLevel: "level1.tmx");

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
