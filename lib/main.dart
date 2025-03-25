import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app_roject/screens/platformer_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlatformerSplash(),
    );
  }
}
