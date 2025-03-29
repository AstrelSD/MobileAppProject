import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/game_screen.dart';

class CharacterSelect extends StatelessWidget {
  const CharacterSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> playerCharacters = ['Virtual Guy', 'male'];

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Character'),
            SizedBox(height: 30),
            ...playerCharacters.map((character) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameScreen(
                                    initialLevel: 'level_3',
                                    character: character,
                                  )));
                    },
                    child: Text('Start Game!!')),
              );
            })
          ],
        ),
      ),
    );
  }
}
