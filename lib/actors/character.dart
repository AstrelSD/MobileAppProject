import 'dart:async';
import 'package:flame/components.dart';
import 'package:mobile_app_roject/game/game_dev.dart';

enum CharacterState { idle, running, jump }

class Character extends SpriteAnimationGroupComponent<CharacterState> with HasGameRef<PlatFormerGameDev> {
  final String character;

  Character({required Vector2 position, required this.character}) : super(position: position);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpAnimation;

  @override
  FutureOr<void> onLoad() async {
    await _loadCharacterAnimations();
    return super.onLoad();
  }

  _loadCharacterAnimations()  {
    idleAnimation = _loadAsepriteAnimation('Idle',11);
    runningAnimation = _loadAsepriteAnimation('Run', 12);
    jumpAnimation = _loadAsepriteAnimation('Jump', 1);

    animations = {
      CharacterState.idle: idleAnimation,
      CharacterState.running: runningAnimation,
      CharacterState.jump: jumpAnimation,
    };

    current = CharacterState.idle; // Set initial state
  }

  SpriteAnimation _loadAsepriteAnimation(String state,int amount) {
      return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime, 
          textureSize: Vector2.all(32)
        )
      );
  }
 
}
