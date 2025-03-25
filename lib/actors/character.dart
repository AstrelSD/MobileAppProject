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
  Future<void> onLoad() async {
    await _loadCharacterAnimations();
    return super.onLoad();
  }

  Future<void> _loadCharacterAnimations() async {
    idleAnimation = await _loadAsepriteAnimation('idle');
    runningAnimation = await _loadAsepriteAnimation('run');
    jumpAnimation = await _loadAsepriteAnimation('jump');

    animations = {
      CharacterState.idle: idleAnimation,
      CharacterState.running: runningAnimation,
      CharacterState.jump: jumpAnimation,
    };

    current = CharacterState.idle; // Set initial state
  }

  Future<SpriteAnimation> _loadAsepriteAnimation(String state) async {
    final image = await gameRef.images.load('Characters/$character/$state.png');
    final jsonData = await gameRef.assets.readJson('Characters/$character/$state.json');
    
    // Manually parse the Aseprite JSON data into the correct animation
      // need to research more on aseprite part

    final frames = jsonData['frames'] as List;
    final textureSize = Vector2.all(32); // Assuming each frame is 32x32 pixels
    final animationFrames = <Sprite>[];

    for (var frame in frames) {
      final x = frame['frame']['x'] as double;
      final y = frame['frame']['y'] as double;
      final width = frame['frame']['w'] as double;
      final height = frame['frame']['h'] as double;
      final sprite = Sprite(image, srcPosition: Vector2(x, y), srcSize: Vector2(width, height));
      animationFrames.add(sprite);
    }

    return SpriteAnimation.spriteList(animationFrames, stepTime: stepTime);
  }
  // Animation control (direct use of `current`)
  void run() => current = CharacterState.running;
  void jump() => current = CharacterState.jump;
  void idle() => current = CharacterState.idle;
}
