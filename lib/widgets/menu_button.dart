import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const MenuButton({ super.key, required this.onPressed, required this.text });

  @override
  Widget build(BuildContext context) {
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
            fontSize: 15,
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
}
