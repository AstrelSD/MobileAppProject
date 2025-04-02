import 'package:mobile_app_roject/levels/base_level.dart';

class Level1 extends Level {
  Level1({required super.character}) : super(activeLevel: "level3.tmx");

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('Character selected: $character');
    loadLevelMechanics();
  }

  @override
  void loadLevelMechanics() {
  }
}