import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/platformer_main_menu.dart';
import 'package:mobile_app_roject/screens/settings/settings_overlay.dart';
import 'package:mobile_app_roject/services/save_manager.dart';
import 'package:mobile_app_roject/models/game_state.dart';

class PauseOverlay extends StatefulWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onSave;
  final int level;
  final int score;
  final int coins;
  final int coconut;
  final int lives;
  final String character;
  final SaveManager saveManager; // Pass SaveManager instance

  PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onSave,
    required this.level,
    required this.score,
    required this.coins,
    required this.coconut,
    required this.lives,
    required this.character, 
    required this.saveManager, // Required SaveManager
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
  
  late int _selectedSlot; // Change selectedSlot to state variable

  @override
  void initState() {
    super.initState();
    _selectedSlot = 1; // Default slot
  }

  void _saveGame() async {
    GameState gameState = GameState(
      level: widget.level,
      score: widget.score,
      coins: widget.coins,
      coconut: widget.coconut,
      character: widget.character,
      lives: widget.lives,
      timestamp: DateTime.now().toUtc() 
    );

    await widget.saveManager.saveGame(_selectedSlot, gameState);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game saved in Slot $_selectedSlot')),
    );
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
            border: Border.all(color: Colors.white, width: 2),
          ),
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
                  _buildPauseButton(Icons.play_arrow, 'Continue', Colors.green, widget.onResume),
                  const SizedBox(width: 40),
                  _buildPauseButton(Icons.refresh, 'Restart', Colors.orange, widget.onRestart),
                  const SizedBox(width: 40),
                  _buildPauseButton(Icons.save, 'Save', Colors.purple, _saveGame),
                  const SizedBox(width: 40),
                  _buildPauseButton(
                    Icons.settings,
                    'Settings',
                    Colors.blue,
                    () => showDialog(context: context, builder: (_) => const SettingsOverlay()),
                  ),
                  const SizedBox(width: 40),
                  _buildPauseButton(Icons.home, 'Home', Colors.red, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PlatformerMainMenu()));
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Text('Select Save Slot:', style: TextStyle(color: Colors.white, fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedSlot = index + 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedSlot == index + 1 ? Colors.green : Colors.grey,
                      ),
                      child: Text('Slot ${index + 1}',
                        style: TextStyle(
                          color: _selectedSlot == index + 1 ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PixelFont',
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(iconSize: 50, icon: Icon(icon, color: color), onPressed: onPressed),
        Text(label, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'PixelFont')),
        const SizedBox(height: 10),
      ],
    );
  }
}
