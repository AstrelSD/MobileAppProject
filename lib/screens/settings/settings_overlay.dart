import 'package:flutter/material.dart';
import 'package:mobile_app_roject/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';

class SettingsOverlay extends StatefulWidget {
  const SettingsOverlay({super.key});

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();

  // Global access to sound settings
  static bool soundEnabled = true;

  // Method to play sound effects globally
  static void playSoundEffect(String file) {
    if (soundEnabled) {
      FlameAudio.play(file, volume: 1.0);
    }
  }
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  String gameMode = 'Normal';
  bool notifications = true;
  bool music = true; 
  bool sound = SettingsOverlay.soundEnabled; // Get initial sound setting

  @override
  void initState() {
    super.initState();
    _applySoundSettings();
  }

  void _applySoundSettings() {
    if (music) {
      FlameAudio.bgm.play('background_music.mp3', volume: 0.5);
    } else {
      FlameAudio.bgm.stop();
    }
  }

  void _toggleMusic(bool newValue) {
    setState(() {
      music = newValue;
      _applySoundSettings();
    });
  }

  void _toggleSound(bool newValue) {
    setState(() {
      sound = newValue;
      SettingsOverlay.soundEnabled = newValue; // Update global sound setting
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.brown[700]!, width: 4.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.brown[700]),
              ),
              const SizedBox(height: 20),

              _settingsRow(
                icon: Icons.videogame_asset,
                label: 'Game Mode',
                content: DropdownButton<String>(
                  value: gameMode,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.brown[700]),
                  iconSize: 30,
                  underline: const SizedBox(),
                  items: <String>['Easy', 'Normal', 'Hard']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => gameMode = newValue!);
                  },
                ),
              ),

              _settingsRow(
                icon: Icons.notifications,
                label: 'Notifications',
                content: Switch(
                  value: notifications,
                  onChanged: (bool newValue) {
                    setState(() => notifications = newValue);
                  },
                  activeColor: Colors.green[400],
                ),
              ),

              _settingsRow(
                icon: Icons.music_note,
                label: 'Music',
                content: Switch(
                  value: music,
                  onChanged: _toggleMusic,
                  activeColor: Colors.green[400],
                ),
              ),

              _settingsRow(
                icon: Icons.volume_up,
                label: 'Sound Effects',
                content: Switch(
                  value: sound,
                  onChanged: _toggleSound,
                  activeColor: Colors.green[400],
                ),
              ),

              _settingsRow(
                icon: Icons.help_outline,
                label: 'Help',
                content: IconButton(
                  icon: Icon(Icons.help, color: Colors.orange[400], size: 30),
                  onPressed: () => print('Help pressed'),
                ),
              ),

              _settingsRow(
                icon: Icons.logout,
                label: 'Log out',
                content: IconButton(
                  icon: Icon(Icons.logout, color: Colors.red[400], size: 30),
                  onPressed: _confirmLogout,
                ),
              ),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
                  onPressed: () {
                    print('Settings saved');
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsRow({
    required IconData icon,
    required String label,
    required Widget content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 30, color: Colors.brown[700]),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
          content
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: _logout,
              child: const Text("Log Out", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
