import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/game_screen.dart';
import 'package:mobile_app_roject/widgets/menu_button.dart';

class CharacterSelect extends StatelessWidget {
  const CharacterSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> playerCharacters = [
      {
        'name': 'Male Character',
        'image': 'assets/images/Main Characters/Male Character/Idle.png'
      },
      {
        'name': 'Female Character',
        'image': 'assets/images/Main Characters/Female Character/Idle.png'
      },
    ];

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.lightBlue[50],
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(
                    width: 5,
                    color: const Color.fromARGB(31, 0, 0, 0),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Character',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: playerCharacters.map((character) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Image.asset(
                                  character['image']!,
                                  width: 100, 
                                  height: 150, 
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                MenuButton(
                                  onPressed: () {
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
                                  text: 'Start Game',
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}