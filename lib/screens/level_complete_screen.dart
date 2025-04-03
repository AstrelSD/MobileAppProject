import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/platformer_main_menu.dart';
import 'package:mobile_app_roject/screens/game_screen.dart';

class LevelCompleteScreen extends StatefulWidget {
  final String initialLevel;
  final String character;

  const LevelCompleteScreen({
    super.key,
    required this.initialLevel,
    required this.character,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isHoveringRestart = false;
  bool _isHoveringMenu = false;
  bool _isHoveringNext = false;

  @override
  void initState() {
    super.initState();
    
    // Play Level Complete Sound
    try {
      FlameAudio.play('levelcomplete.wav', volume: 1.0);
      print("Playing level complete sound.");
    } catch (e) {
      print("Error playing level complete sound: $e");
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green[900]!,
                  Colors.green[800]!,
                  Colors.black87,
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value * 0.3,
                child: Center(
                  child: Container(
                    width: 300 * _scaleAnimation.value,
                    height: 300 * _scaleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green[700],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.7),
                          blurRadius: 100 * _scaleAnimation.value,
                          spreadRadius: 20 * _scaleAnimation.value,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Text(
                        'LEVEL COMPLETE!',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.black,
                          fontFamily: 'PixelFont',
                          letterSpacing: 4,
                        ),
                      ),
                      Text(
                        'LEVEL COMPLETE!',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'PixelFont',
                          letterSpacing: 4,
                          shadows: const [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You have completed the level!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'PixelFont',
                    ),
                  ),
                  const SizedBox(height: 40),
                  // "Next Level" button only shows if initialLevel < 3
                  _buildAnimatedButton(
                    widget.initialLevel == '3'
                        ? 'You Completed All Levels'
                        : 'Next Level',
                    _isHoveringNext,
                    Colors.orange[700]!,
                    widget.initialLevel == '3'
                        ? () {} // Do nothing, or show a dialog if needed
                        : () {
                            int nextLevel = int.parse(widget.initialLevel) + 1;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameScreen(
                                  initialLevel: nextLevel.toString(),
                                  character: widget.character,
                                ),
                              ),
                            );
                          },
                    onHover: (hovering) {
                      setState(() => _isHoveringNext = hovering);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildAnimatedButton(
                    'Restart',
                    _isHoveringRestart,
                    Colors.green[700]!,
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(
                            initialLevel: widget.initialLevel,
                            character: widget.character,
                          ),
                        ),
                      );
                    },
                    onHover: (hovering) {
                      setState(() => _isHoveringRestart = hovering);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildAnimatedButton(
                    'Main Menu',
                    _isHoveringMenu,
                    Colors.blue[700]!,
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlatformerMainMenu(),
                        ),
                      );
                    },
                    onHover: (hovering) {
                      setState(() => _isHoveringMenu = hovering);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(
    String text,
    bool isHovering,
    Color color,
    VoidCallback onPressed, {
    required Function(bool) onHover,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isHovering ? 1.05 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
          boxShadow: [
            if (isHovering)
              BoxShadow(
                color: color.withOpacity(0.7),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'PixelFont',
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
