import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/character_select.dart';
import 'package:mobile_app_roject/widgets/menu_button.dart';
import 'package:mobile_app_roject/screens/settings/settings_overlay.dart';

class PlatformerMainMenu extends StatelessWidget {
  const PlatformerMainMenu({super.key});

  Widget buildMenuButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
                color: const Color.fromARGB(255, 50, 50, 37), width: 4),
          ),
          elevation: 10,
          shadowColor: Colors.black,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontFamily: 'PixelFont',
            shadows: [
              Shadow(
                blurRadius: 5,
                color: Colors.black,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'Srilankan Diaries',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 37, 68, 4),
                    fontFamily: 'PixelFont',
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: const Color.fromARGB(255, 222, 255, 178),
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                MenuButton(
                    text: 'Continue',
                    onPressed: () {
                      // Navigate to the game screen
                    }),
                SizedBox(height: 15),
                MenuButton(
                    text: 'New Game',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CharacterSelect()));
                    }),
                SizedBox(height: 15),
                MenuButton(
                  text: 'Settings',
                  onPressed:  () {
                  showDialog(
                      context: context,
                      builder: (context) => const SettingsOverlay(),
                  );
                }),
                SizedBox(height: 15),
                MenuButton(
                    text: 'Exit',
                    onPressed: () {
                      // Exit the app
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
