import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/platformer_splash.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp( const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PlatformerSplash(),
  ));
}

