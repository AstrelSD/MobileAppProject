import 'dart:ui';

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
        'image': 'assets/images/Main Characters/Male Character/Idle2.png'
      },
      {
        'name': 'Female Character',
        'image': 'assets/images/Main Characters/Female Character/Idle2.png'
      },
    ];

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: Colors.lightGreen,
            )),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.lightGreen.withAlpha(240),
                ),
              ),
            ),
            Center(
                child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(
                  width: 5,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Character',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
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
                                          initialLevel: 'level1',
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
            )),
          ],
        ),
      ),
    );
  }
}
