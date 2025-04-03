import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app_roject/screens/settings/settings_overlay.dart';
import 'firebase_options.dart';
import 'package:mobile_app_roject/screens/platformer_splash.dart';
import 'package:mobile_app_roject/screens/login_screen.dart';
import 'package:flame_audio/flame_audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Flame.device.fullScreen();
  Flame.device.setLandscape();

    await FlameAudio.audioCache.loadAll(['jump.wav']);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => LoginScreen(),
        '/splash': (context) => PlatformerSplash(),
        '/settings': (context) =>SettingsOverlay(),
      },
    );
  }
}

// 🔹 Handles authentication state changes
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return PlatformerSplash();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
