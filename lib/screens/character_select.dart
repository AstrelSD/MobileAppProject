import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/game_screen.dart';
import 'package:mobile_app_roject/widgets/menu_button.dart';

class CharacterSelect extends StatelessWidget {
  const CharacterSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> playerCharacters = [
      {
        'name': 'Virtual Guy',
        'image': 'assets/images/Main Characters/Virtual Guy/Idle (32x32).png',
        'description': 'The default character with balanced abilities'
      },
      {
        'name': 'Male Character',
        'image': 'assets/images/Main Characters/Male Character/Idle.png',
        'description': 'Strong but slower movement'
      },
      {
        'name': 'Female Character',
        'image': 'assets/images/Main Characters/Female Character/Idle.png',
        'description': 'Fast but weaker jumps'
      },
    ];

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Your Character',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...playerCharacters.map((character) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Image.asset(
                      character['image']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      character['name']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      character['description']!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(
                            initialLevel: 'level3',
                            character: character['name']!,
                          ),
                        ),
                      );
                    },
                    tileColor: Colors.blueGrey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
