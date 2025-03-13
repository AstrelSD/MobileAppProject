import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app_roject/screens/platformer_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize Hive for Flutter
  // await Hive.initFlutter();
  // await Hive.openBox('gameData'); 

  // Set screen orientation to landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PlatformerSplash(),
  ));
}
