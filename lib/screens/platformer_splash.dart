import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/platformer_main_menu.dart';

class PlatformerSplash extends StatelessWidget {
  const PlatformerSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Wrap the image with a flexible widget to avoid overflow
          Flexible(
            child: Image.asset("assets/images/Forest.png"),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(), // Show progress indicator
        ],
      ),
      nextScreen: PlatformerMainMenu(),
      splashTransition: SplashTransition.scaleTransition,
      splashIconSize: 200,
      backgroundColor: Colors.black,
    );
  }
}
