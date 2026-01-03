import 'package:flutter/material.dart';

class CustomWidgets {
  // custom textFields
  static Widget customTextField({
    required TextEditingController controller,
    required String label,
    IconData? suffixIcon,
    required bool obscureText,
  }) {
    return TextField(
      decoration: InputDecoration(
        label: Text(label, style: TextStyle(fontSize: 20)),
        suffixIcon: (suffixIcon == null)
            ? null
            : Icon(
                suffixIcon,
                size: 30,
                // color: Color.fromARGB(100, 59, 141, 155),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      obscureText: obscureText,
    );
  }

  // home screen cards
  static Widget homeScreenCard({
    required VoidCallback onTap,
    required String imageAsset,
    required String title,
    required Size size,
  }) {
    return Container(
      width: size.width * 0.43,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
          begin: .topLeft,
          end: .bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(2.5),
      child: Card(
        color: Colors.white,
        margin: .zero,
        elevation: 0,
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          onTap: onTap,
          title: Center(
            child: Image(
              image: AssetImage(imageAsset),
              height: size.width * 0.11,
            ),
          ),
          subtitle: Center(child: Text(title, style: TextStyle(fontSize: 20))),
        ),
      ),
    );
  }
}
