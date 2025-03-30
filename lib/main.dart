import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app_roject/screens/platformer_splash.dart';
import 'package:mobile_app_roject/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Listen to authentication changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Check if the user is logged in or not
            if (snapshot.hasData) {
              return PlatformerSplash(); // User is logged in
            } else {
              return LoginScreen(); // User is not logged in
            }
          } else {
            return Center(child: CircularProgressIndicator()); // Show loading spinner while checking auth state
          }
        },
      ),
    );
  }
}
