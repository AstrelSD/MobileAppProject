import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/platformer_main_menu.dart';
import 'package:mobile_app_roject/screens/game_screen.dart';

class GameOverScreen extends StatefulWidget {
  final String initialLevel;
  final String character;

  const GameOverScreen({
    super.key,
    required this.initialLevel,
    required this.character,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isHoveringRestart = false;
  bool _isHoveringMenu = false;

  @override
  void initState() {
    super.initState();
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
                  Colors.red[900]!,
                  Colors.red[800]!,
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
                      color: Colors.red[700],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.7),
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
                        'GAME OVER',
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
                        'GAME OVER',
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
                    'Your adventure has ended...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'PixelFont',
                    ),
                  ),
                  const SizedBox(height: 40),
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
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Try again to beat your score!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'PixelFont',
                ),
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
