import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/character_select.dart';
import 'package:mobile_app_roject/widgets/menu_button.dart';
import 'package:mobile_app_roject/screens/settings/settings_overlay.dart';

class PlatformerMainMenu extends StatelessWidget {
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app_roject/screens/game_screen.dart';
import 'package:mobile_app_roject/screens/sign_in_page.dart';

class PlatformerMainMenu extends StatefulWidget {
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
  _PlatformerMainMenuState createState() => _PlatformerMainMenuState();
}

class _PlatformerMainMenuState extends State<PlatformerMainMenu> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String? lastLevel; // Stores the last played level
  bool isLoading = true; // Shows loading indicator

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  // Check if user is signed in and get progress
  Future<void> _checkUserStatus() async {
    user = _auth.currentUser;

    if (user != null) {
      // Fetch last level from Firestore
      DocumentSnapshot progressSnapshot =
          await _firestore.collection('progress').doc(user!.uid).get();

      if (progressSnapshot.exists) {
        setState(() {
          lastLevel = progressSnapshot.get('lastLevel') ?? 'level_1';
        });
      }
    }

    setState(() {
      isLoading = false; // Hide loading spinner
    });
  }

  // Sign out function
  Future<void> _signOut() async {
    await _auth.signOut();
    setState(() {
      user = null; // Reset user state
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
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
                ? CircularProgressIndicator() // Show loading while fetching data
                : Column(
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

                      // Show "Continue" if user is signed in, otherwise "Sign In"
                      buildMenuButton(user != null ? 'Continue' : 'Sign In', () {
                        if (user != null && lastLevel != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameScreen(initialLevel: lastLevel!),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        }
                      }),

                      SizedBox(height: 15),

                      // "New Game" starts from level_1
                      buildMenuButton('New Game', () {
                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GameScreen(initialLevel: 'level_1')));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        }
                      }),

                      SizedBox(height: 15),
                      buildMenuButton('Settings', () {
                        // Navigate to the settings screen
                      }),

                      SizedBox(height: 15),
                      buildMenuButton('Exit', () {
                        // Exit the app
                      }),

                      // Show "Sign Out" only if user is logged in
                      if (user != null) ...[
                        SizedBox(height: 15),
                        buildMenuButton('Sign Out', _signOut),
                      ]
                    ],
                  ),
                ),
                SizedBox(height: 30),
                MenuButton(
                    text: 'Continue',
                    onPressed: () {
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
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
