import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/platformer_main_menu.dart';
import 'package:mobile_app_roject/screens/settings/settings_overlay.dart';

class PauseOverlay extends StatefulWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onSave;

  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onSave,
  });

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay> {
  bool _isHoveringResume = false;
  bool _isHoveringRestart = false;
  bool _isHoveringSettings = false;
  bool _isHoveringHome = false;
  bool _isHoveringSave = false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.darken,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PAUSED',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'PixelFont',
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPauseButton(
                      Icons.play_arrow,
                      'Continue',
                      _isHoveringResume,
                      Colors.green,
                      widget.onResume,
                      onHover: (hovering) {
                        setState(() => _isHoveringResume = hovering);
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildPauseButton(
                      Icons.refresh,
                      'Restart',
                      _isHoveringRestart,
                      Colors.orange,
                      widget.onRestart,
                      onHover: (hovering) {
                        setState(() => _isHoveringRestart = hovering);
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildPauseButton(
                      Icons.save,
                      'Save',
                      _isHoveringSave,
                      Colors.purple,
                      widget.onSave,
                      onHover: (hovering) {
                        setState(() => _isHoveringSave = hovering);
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildPauseButton(
                      Icons.settings,
                      'Settings',
                      _isHoveringSettings,
                      Colors.blue,
                      () {
                        showDialog(
                          context: context,
                          builder: (context) => const SettingsOverlay(),
                        );
                      },
                      onHover: (hovering) {
                        setState(() => _isHoveringSettings = hovering);
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildPauseButton(
                      Icons.home,
                      'Home',
                      _isHoveringHome,
                      Colors.red,
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlatformerMainMenu(),
                          ),
                        );
                      },
                      onHover: (hovering) {
                        setState(() => _isHoveringHome = hovering);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseButton(
    IconData icon,
    String label,
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
        transform: Matrix4.identity()..scale(isHovering ? 1.1 : 1.0),
        child: Column(
          children: [
            IconButton(
              iconSize: 50,
              icon: Icon(
                icon,
                color: color,
              ),
              onPressed: onPressed,
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
