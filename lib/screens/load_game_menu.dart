import 'package:flutter/material.dart';
import 'package:mobile_app_roject/widgets/menu_button.dart';
import 'package:mobile_app_roject/models/game_state.dart';
import 'package:mobile_app_roject/services/save_manager.dart';
import 'package:mobile_app_roject/screens/game_screen.dart';

class LoadGameMenu extends StatefulWidget {
  const LoadGameMenu({super.key});

  @override
  _LoadGameMenuState createState() => _LoadGameMenuState();
}

class _LoadGameMenuState extends State<LoadGameMenu> {
  final SaveManager _saveManager = SaveManager();
  List<int> usedSlots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsedSlots();
  }

  Future<void> _fetchUsedSlots() async {
    try {
      List<int> slots = await _saveManager.getUsedSlots();
      setState(() {
        usedSlots = slots;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching save slots: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadGame(int slot) async {
  try {
    GameState? gameState = await _saveManager.loadGame(slot);
    if (gameState != null) {
      print('Loaded Game from Slot $slot');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            initialLevel: 'level_${gameState.level}',  
            character: gameState.character, 
            loadedState: gameState, 
          ),
        ),
      );
    } else {
      print('No game data found in Slot $slot');
    }
  } catch (e) {
    print('Error loading game: $e');
  }
}


  Widget _buildSaveSlotButton(int slot) {
    bool isSlotUsed = usedSlots.contains(slot);
    return MenuButton(
      text: 'Slot $slot',
      onPressed: isSlotUsed ? () => _loadGame(slot) : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Forest.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withAlpha(50),
          ),
          Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Load Game',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 37, 68, 4),
                          fontFamily: 'PixelFont',
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Color.fromARGB(255, 222, 255, 178),
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildSaveSlotButton(1),
                      SizedBox(height: 15),
                      _buildSaveSlotButton(2),
                      SizedBox(height: 15),
                      _buildSaveSlotButton(3),
                      SizedBox(height: 30),
                      MenuButton(
                        text: 'Back',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
