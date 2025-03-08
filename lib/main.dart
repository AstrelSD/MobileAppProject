import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/platformer_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PlatformerSplash(),
  ));
}

