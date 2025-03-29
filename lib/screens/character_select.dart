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
        'image': 'assets/images/Main Characters/Virtual Guy/Idle (32x32).png'
      },
      {
        'name': 'Male',
        'image': 'assets/images/Main Characters/Virtual Guy/Idle (32x32).png'
      },
    ];

    final screenX = MediaQuery.of(context).size.width;
    final screenY = MediaQuery.of(context).size.height;

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
                padding: EdgeInsets.all(10),
                width: screenX * 0.7,
                height: screenY * 0.7,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(
                      width: 5,
                      color: const Color.fromARGB(31, 0, 0, 0),
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select Character',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...playerCharacters.map((character) {
                          return Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  character['image']!,
                                  width: 100, // Adjust image width
                                  height: 100, // Adjust image height
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 10),
                                MenuButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameScreen(
                                          initialLevel: 'level_3',
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
                        })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
