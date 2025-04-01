import 'package:mobile_app_roject/levels/base_level.dart';

class Level2 extends Level {
  Level2({required super.character}) : super(activeLevel: "level3.tmx");

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('Character selected: $character');
    loadLevelMechanics();
  }

  @override
  void loadLevelMechanics() {
    print('Level3-specific mechanics added');
  }
}
