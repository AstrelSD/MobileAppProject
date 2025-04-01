import 'package:flutter/material.dart';

class SettingsOverlay extends StatefulWidget {
  const SettingsOverlay ({super.key});

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  String gameMode = 'Normal';
  bool notifications = true;
  bool music = true;
  bool sound = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.brown[700]!,
              width: 4.0
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7
            ),
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
                    color: Colors.brown[700]
                ),
              ),
              const SizedBox(height: 20),
              //Game mode
              _settingsRow(
                icon: Icons.videogame_asset,
                label: 'Game Mode',
                content: DropdownButton<String>(
                  value: gameMode,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.brown[700],),
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
              //Notifications
              _settingsRow(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  content: Switch(
                    value: notifications,
                    onChanged: (bool newValue) {
                      setState(() => notifications = newValue);
                    },
                    activeColor: Colors.green[400],
                  )
              ),
              //Music
              _settingsRow(
                  icon: Icons.music_note,
                  label: 'Music',
                  content: Switch(
                    value: music,
                    onChanged: (bool newValue) {
                      setState(() => music = newValue);
                    },
                    activeColor: Colors.green[400],
                  )
              ),
              //Sound
              _settingsRow(
                  icon: Icons.volume_up,
                  label: 'Sound',
                  content: Switch(
                    value: sound,
                    onChanged: (bool newValue) {
                      setState(() => sound = newValue);
                    },
                    activeColor: Colors.green[400],
                  )
              ),
              //Help
              _settingsRow(
                  icon: Icons.help_outline,
                  label: 'Help',
                  content: IconButton(
                    icon: Icon(Icons.help,
                        color: Colors.orange[400],
                        size: 30),
                    onPressed: () => print('Help pressed'),
                  )
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                  ),
                  onPressed: () {
                    print('Settings saved');
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(color:
                    Colors.white,
                        fontSize: 18),
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
              Text(
                label,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          content
        ],
      ),
    );
  }
}