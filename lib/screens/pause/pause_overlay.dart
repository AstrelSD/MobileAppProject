import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/platformer_main_menu.dart';
import 'package:mobile_app_roject/screens/settings/settings_overlay.dart';
import 'package:mobile_app_roject/services/save_manager.dart';  // Import SaveManager
import 'package:mobile_app_roject/models/game_state.dart';  // Import GameState model

class PauseOverlay extends StatefulWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onSave;
  final int level;
  final int score;
  final int coins;
  final int gold;
  final int lives;

  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onSave,
    required this.level,
    required this.score,
    required this.coins,
    required this.gold,
    required this.lives,
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
  int selectedSlot = 1; // To track the selected save slot

  final SaveManager _saveManager = SaveManager(); // Instance of SaveManager

  // Save the game to Firestore
  void _saveGame() async {
    // Create a GameState object with actual game data
    GameState gameState = GameState(
      level: widget.level,
      score: widget.score,
      coins: widget.coins,
      gold: widget.gold,
      lives: widget.lives,
    );

    // Save game data to the selected slot
    await _saveManager.saveGame(selectedSlot, gameState);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game saved in Slot $selectedSlot')),
    );
  }

  // Load the game from a specific slot (optional for future use)
  void _loadGame() async {
    GameState? loadedGame = await _saveManager.loadGame(selectedSlot);
    if (loadedGame != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loaded Slot $selectedSlot')),
      );
      // You can also update the game state here based on the loaded data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No save data in Slot $selectedSlot')),
      );
    }
  }

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
                      _saveGame, // Save game action
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
                const SizedBox(height: 20),
                // Save Slot Selection Buttons
                Text('Select Save Slot:', style: TextStyle(color: Colors.white, fontSize: 18)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedSlot = index + 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedSlot == index + 1 ? Colors.green : Colors.grey,
                        ),
                        child: Text('Slot ${index + 1}'),
                      ),
                    );
                  }),
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
